import 'package:borderlands_perks/models/build.dart';
import 'package:borderlands_perks/models/perk.dart';
import 'package:flutter/material.dart';

class BuildManager extends ChangeNotifier {
  List<Build> builds = [];

  BuildManager();

  Build getBuild(int index) {
    return builds[index];
  }

  void addBuild(Build build) {
    builds.add(build);

    notifyListeners();
  }

  void removeBuild(Build build) {
    builds.remove(build);

    notifyListeners();
  }

  void load(Build build) async {
    await build.loadPerks();

    notifyListeners();
  }

  void assignSkillPoint(Build build, Perk perk, int tree) {
    build.assignSkillPoint(perk, tree);

    notifyListeners();
  }

  void removeSkillPoint(Build build, Perk perk, int tree) {
    build.removeSkillPoint(perk, tree);

    notifyListeners();
  }
}
