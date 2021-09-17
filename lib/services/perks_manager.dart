import 'dart:convert';

import 'package:borderlands_perks/models/active_attribut.dart';
import 'package:borderlands_perks/models/attribut.dart';
import 'package:borderlands_perks/models/perk.dart';
import 'package:borderlands_perks/models/perks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const int maxSkillsPoint = 70;

class PerksManager extends ChangeNotifier {
  int _skillsPoint = maxSkillsPoint;
  final Map<String, int> _selectedPerks = <String, int>{};
  final List<Perks> _perks = [];
  bool loading = false;
  bool perksRetrieved = false;

  int get skillsPoint => _skillsPoint;
  int get _usedPoints => maxSkillsPoint - _skillsPoint;
  int get _usedPointsOnPassiveSkills => _calcUsedPointsOnPassiveSkills();
  int get maxSkillPoints => maxSkillsPoint;

  void load(List<String> paths) async {
    loading = true;

    for (var path in paths) {
      String content = await rootBundle.loadString(path);

      var decoded = jsonDecode(content) as List;
      List<Perk> perks = decoded.map((perk) => Perk.fromJson(perk)).toList();

      perks.sort((a, b) => a.compareTo(b));

      _perks.add(Perks(perks: perks));
    }

    perksRetrieved = true;
    loading = false;

    notifyListeners();
  }

  Perks? getPerks(int index) {
    if (index >= _perks.length) return null;
    return _perks.elementAt(index);
  }

  bool isPerkLocked(Perk perk) {
    return perk.isLocked(_usedPointsOnPassiveSkills);
  }

  int getAssignedPoints(Perk perk) {
    if (_selectedPerks.containsKey(perk.id)) {
      return _selectedPerks[perk.id]!;
    }
    return 0;
  }

  String assignSkillPoint(Perk perk) {
    if (_skillsPoint == 0) return "No more skill points";

    if (perk.isLocked(_usedPoints)) {
      return "Not enough skill points used to unlock";
    }

    if (_selectedPerks.containsKey(perk.id)) {
      if (perk.canAddSkillPoint(_selectedPerks[perk.id]!)) {
        _selectedPerks[perk.id] = _selectedPerks[perk.id]! + 1;
        --_skillsPoint;
      } else {
        return "Perk has reached is maximum";
      }
    } else {
      _selectedPerks[perk.id] = 1;
      --_skillsPoint;
    }

    notifyListeners();

    return "";
  }

  bool removeSkillPoint(Perk perk) {
    if (!_selectedPerks.containsKey(perk.id)) {
      return false;
    }

    _selectedPerks[perk.id] = _selectedPerks[perk.id]! - 1;
    if (_selectedPerks[perk.id] == 0) {
      _selectedPerks.remove(perk.id);
    }
    ++_skillsPoint;

    notifyListeners();

    return true;
  }

  bool isSelected(String perkID) {
    return _selectedPerks.containsKey(perkID);
  }

  List<ActiveAttribut> getActiveAttributs() {
    List<Perk> selectedPerks = _getSelectedPerks();
    Map<String, List<ActiveAttribut>> values = <String, List<ActiveAttribut>>{};

    for (var perk in selectedPerks) {
      for (var attrib in perk.attributs) {
        var currentValue =
            _getAttribCurrentValue(_selectedPerks[perk.id]!, attrib);

        if (!values.containsKey(attrib.name)) {
          values[attrib.name] = [];
        }
        values[attrib.name]!.add(ActiveAttribut(
            name: attrib.name,
            unit: attrib.unit,
            value: currentValue,
            activation: attrib.activation));
      }
    }

    List<ActiveAttribut> toReturn = [];
    values.forEach((key, list) {
      num value = 0;

      for (var val in list) {
        value = value + val.value;
      }

      toReturn.add(ActiveAttribut(
          name: key,
          unit: list[0].unit,
          value: value,
          activation: list[0].activation));
    });

    return toReturn;
  }

  num _getAttribCurrentValue(int level, Attribut attrib) {
    if (attrib.values.length == 1) {
      return attrib.values[0];
    }
    return attrib.values[level - 1];
  }

  List<Perk> _getSelectedPerks() {
    List<Perk> toReturn = [];

    for (var perks in _perks) {
      toReturn.addAll(
          perks.perks.where((perk) => _selectedPerks.containsKey(perk.id)));
    }

    return toReturn;
  }

  int _calcUsedPointsOnPassiveSkills() {
    int used = 0;

    for (var perks in _perks) {
      perks.perks
          .where((perk) => _selectedPerks.containsKey(perk.id))
          .forEach((perk) {
        if (perk.perkType == Fl4kPerkType.passive) {
          used += _selectedPerks[perk.id]!;
        }
      });
    }

    return used;
  }
}
