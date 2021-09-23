import 'dart:convert';

import 'package:borderlands_perks/models/active_attribut.dart';
import 'package:borderlands_perks/models/attribut.dart';
import 'package:borderlands_perks/models/character.dart';
import 'package:borderlands_perks/models/perk.dart';
import 'package:borderlands_perks/models/perks.dart';
import 'package:borderlands_perks/services/business_exception.dart';
import 'package:borderlands_perks/services/storage.dart';
import 'package:flutter/services.dart';

const int maxSkillsPoint = 70;
const int maxAugmentSkills = 3;

Character parseCharacter(String value) {
  switch (value) {
    case "FL4K":
      return Character.fl4k;
    case "AMARA":
      return Character.amara;
    case "MOZE":
      return Character.moze;
    case "ZANE":
      return Character.zane;
    default:
      return Character.none;
  }
}

class Build {
  List<SkillTree> trees = [];
  final String name;
  final Character character;
  final String id;

  bool modified = false;
  bool perksLoaded = false;

  Build({required this.name, required this.character, required this.id});

  static Future<Build> fromJson(dynamic json) async {
    Character character = parseCharacter(json['character']);
    Build build = Build(
        name: json['name'] as String, character: character, id: json['id']);
    await build.loadPerks();

    var trees = jsonDecode(json['trees']) as List;
    for (int i = 0; i < trees.length; i++) {
      var selectedPerks =
          jsonDecode(trees[i]['selectedPerks']) as Map<String, dynamic>;
      selectedPerks.forEach((key, value) {
        build.trees[i].setSelectedPerks(selectedPerks);
      });
    }

    return build;
  }

  int get skillPoints {
    int points = maxSkillPoints;

    for (var tree in trees) {
      points -= tree.usedPoints;
    }

    return points;
  }

  bool get isLoaded => perksLoaded;

  int get maxSkillPoints => maxSkillsPoint;

  /* ---------- PUBLIC ---------- */

  Future<void> save() async {
    if (await Storage().exists(id)) {
      await Storage().updateBuild(this);
    } else {
      await Storage().insertBuild(this);
    }
    modified = false;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'character': character.name,
      'trees': jsonEncode(trees)
    };
  }

  Future<void> loadPerks() async {
    List<String> paths = character.getPaths();

    for (var path in paths) {
      String content = await rootBundle.loadString(path);

      var decoded = jsonDecode(content) as List;
      List<Perk> perks = decoded.map((perk) => Perk.fromJson(perk)).toList();

      perks.sort((a, b) => a.compareTo(b));

      trees.add(SkillTree(perks: Perks(perks: perks)));
    }

    perksLoaded = true;
  }

  bool isPerkLocked(Perk perk, int tree) {
    return trees[tree].isPerkLocked(perk);
  }

  int getAssignedPoints(String perkID, int tree) {
    return trees[tree].getAssignedPoints(perkID);
  }

  bool isSelected(String perkID, int tree) {
    return trees[tree].isSelected(perkID);
  }

  Perks? getPerks(int index) {
    if (index >= trees.length) return null;
    return trees.elementAt(index).perks;
  }

  void assignSkillPoint(Perk perk, int tree) {
    if (perk.perkType == Fl4kPerkType.actionSkill && _isActionSkillSeleted()) {
      throw const BusinessException("An Action Skill is already selected");
    } else if (perk.perkType == Fl4kPerkType.pet && _isPetSeleted()) {
      throw const BusinessException("A Pet is already selected");
    } else if (perk.perkType == Fl4kPerkType.augment) {
      if (!_isRequiredActionSkillSelected(tree)) {
        throw const BusinessException(
            "Cannot select augment skill when the required action skill isn't selected");
      } else if (_isNumberOfAugmentMaximumReached(tree)) {
        throw const BusinessException(
            "Cannot select more than $maxAugmentSkills augment skills");
      }
    }

    trees[tree].assignSkillPoint(perk, skillPoints);
    modified = true;
  }

  void removeSkillPoint(Perk perk, int tree) {
    trees[tree].removeSkillPoint(perk);
    modified = true;
  }

  List<ActiveAttribut> getActiveAttributs() {
    List<ActiveAttribut> attribs = [];

    for (var tree in trees) {
      attribs.addAll(tree.getActiveAttributs());
    }

    return attribs;
  }

  /* ---------- PRIVATE ---------- */
  bool _isActionSkillSeleted() {
    for (var tree in trees) {
      if (tree.isActionSkillSelected()) {
        return true;
      }
    }

    return false;
  }

  bool _isPetSeleted() {
    for (var tree in trees) {
      if (tree.isPetSelected()) {
        return true;
      }
    }

    return false;
  }

  bool _isRequiredActionSkillSelected(int tree) {
    return trees[tree].isActionSkillSelected();
  }

  bool _isNumberOfAugmentMaximumReached(int tree) {
    return trees[tree].countAugmentSkills() >= maxAugmentSkills;
  }
}

class SkillTree {
  final Perks perks;
  Map<String, int> _selectedPerks = <String, int>{};

  int usedPoints = 0;

  SkillTree({required this.perks});

  int get _usedPointsOnPassiveSkills => _calcUsedPointsOnPassiveSkills();

  /* ---------- PUBLIC ---------- */

  void setSelectedPerks(Map<String, dynamic> map) {
    _selectedPerks = Map.from(map);
    usedPoints =
        _selectedPerks.values.reduce((value, element) => value + element);
  }

  Map toJson() {
    return {'selectedPerks': jsonEncode(_selectedPerks)};
  }

  void removeSkillPoint(Perk perk) {
    if (!_selectedPerks.containsKey(perk.id)) {
      throw const BusinessException("Cannot remove point of unselected perk");
    }

    _selectedPerks[perk.id] = _selectedPerks[perk.id]! - 1;
    if (_selectedPerks[perk.id] == 0) {
      _selectedPerks.remove(perk.id);
    }
    usedPoints--;
  }

  void assignSkillPoint(Perk perk, int skillPoints) {
    if (skillPoints == 0) throw const BusinessException("No more skill points");

    if (perk.isLocked(usedPoints)) {
      throw const BusinessException("Not enough skill points used to unlock");
    }

    if (_selectedPerks.containsKey(perk.id)) {
      if (perk.canAddSkillPoint(_selectedPerks[perk.id]!)) {
        _selectedPerks[perk.id] = _selectedPerks[perk.id]! + 1;
        usedPoints++;
      } else {
        throw const BusinessException("Perk has reached is maximum");
      }
    } else {
      _selectedPerks[perk.id] = 1;
      usedPoints++;
    }
  }

  bool isSelected(String perkID) {
    return _selectedPerks.containsKey(perkID);
  }

  int getAssignedPoints(String perkID) {
    if (_selectedPerks.containsKey(perkID)) {
      return _selectedPerks[perkID]!;
    }
    return 0;
  }

  bool isPerkLocked(Perk perk) {
    return perk.isLocked(_usedPointsOnPassiveSkills);
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

  bool isActionSkillSelected() {
    for (var perk in _getSelectedPerks()) {
      if (perk.perkType == Fl4kPerkType.actionSkill) {
        return true;
      }
    }

    return false;
  }

  bool isPetSelected() {
    for (var perk in _getSelectedPerks()) {
      if (perk.perkType == Fl4kPerkType.pet) {
        return true;
      }
    }

    return false;
  }

  int countAugmentSkills() {
    int count = 0;

    for (var perk in _getSelectedPerks()) {
      if (perk.perkType == Fl4kPerkType.augment) {
        count++;
      }
    }

    return count;
  }

  /* ---------- PRIVATES ---------- */
  num _getAttribCurrentValue(int level, Attribut attrib) {
    if (attrib.values.length == 1) {
      return attrib.values[0];
    }
    return attrib.values[level - 1];
  }

  List<Perk> _getSelectedPerks() {
    return perks.perks
        .where((perk) => _selectedPerks.containsKey(perk.id))
        .toList();
  }

  int _calcUsedPointsOnPassiveSkills() {
    int used = 0;

    perks.perks
        .where((perk) => _selectedPerks.containsKey(perk.id))
        .forEach((perk) {
      if (perk.perkType == Fl4kPerkType.passive) {
        used += _selectedPerks[perk.id]!;
      }
    });

    return used;
  }
}
