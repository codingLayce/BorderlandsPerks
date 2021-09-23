import 'package:borderlands_perks/models/build.dart';
import 'package:borderlands_perks/models/perk.dart';
import 'package:borderlands_perks/services/storage.dart';
import 'package:flutter/material.dart';

class BuildManager extends ChangeNotifier {
  List<Build> builds = [];
  bool buildsRetrieved = false;

  BuildManager();

  Build getBuild(int index) {
    return builds[index];
  }

  void save(Build build) async {
    await build.save();

    notifyListeners();
  }

  void loadBuildsFromStorage() async {
    builds = await Storage().builds();

    buildsRetrieved = true;

    notifyListeners();
  }

  void addBuild(Build build) {
    builds.add(build);

    notifyListeners();
  }

  void removeBuild(Build build) {
    Storage().removeBuild(build.id);
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
