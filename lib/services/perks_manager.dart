import 'dart:convert';

import 'package:borderlands_perks/models/perk.dart';
import 'package:borderlands_perks/models/perks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const int maxSkillsPoint = 70;

class PerksManager extends ChangeNotifier {
  int _skillsPoint = maxSkillsPoint;
  final Map<int, int> _selectedPerks = <int, int>{};
  final List<Perks> _perks = [];
  String error = "";
  bool loading = false;
  bool perksRetrieved = false;

  Perks get perks => _perks[0];
  int get skillsPoint => _skillsPoint;
  int get _usedPoints => maxSkillsPoint - _skillsPoint;

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
    return perk.isLocked(_usedPoints);
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

  bool isSelected(int perkID) {
    return _selectedPerks.containsKey(perkID);
  }
}
