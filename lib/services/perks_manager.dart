import 'package:borderlands_perks/models/perk.dart';
import 'package:flutter/material.dart';

const maxSkillsPoint = 70;

class PerksManager extends ChangeNotifier {
  int _skillsPoint = maxSkillsPoint;
  final Map<Perk, int> _perks = <Perk, int>{};

  int get skillsPoint => _skillsPoint;

  bool assignSkillPoint(Perk perk) {
    if (_skillsPoint == 0) return false;

    --_skillsPoint;
    if (_perks.containsKey(perk)) {
      _perks[perk] = _perks[perk]! + 1;
    } else {
      _perks[perk] = 1;
    }

    notifyListeners();

    return true;
  }

  bool removeSkillPoint(Perk perk) {
    if (!_perks.containsKey(perk)) {
      return false;
    }

    _perks[perk] = _perks[perk]! - 1;
    ++_skillsPoint;

    notifyListeners();

    return true;
  }

  bool isSelected(Perk perk) {
    return _perks.containsKey(perk);
  }
}
