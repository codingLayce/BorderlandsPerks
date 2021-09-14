import 'package:borderlands_perks/models/perk.dart';

class Perks {
  List<Perk> perks;

  Perks({required this.perks});

  List<Perk> getPerksOfLevel(int level) {
    List<Perk> levelPerks = [];

    for (var perk in perks) {
      if (perk.treeLevel == level) levelPerks.add(perk);
    }

    return levelPerks;
  }

  Map<int, List<Perk>> getPerks() {
    Map<int, List<Perk>> map = <int, List<Perk>>{};

    for (var perk in perks) {
      if (!map.containsKey(perk.treeLevel)) {
        map[perk.treeLevel] = [];
      }
      map[perk.treeLevel]?.add(perk);
    }

    return map;
  }
}
