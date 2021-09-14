import 'dart:convert';

import 'package:borderlands_perks/models/perk.dart';
import 'package:flutter/services.dart';

class Perks {
  List<Perk> perks;

  Perks({required this.perks});

  static Future<Perks> load(String path) async {
    String content = await rootBundle.loadString(path);

    var decoded = jsonDecode(content) as List;
    List<Perk> perks = decoded.map((perk) => Perk.fromJson(perk)).toList();

    perks.sort((a, b) => a.compareTo(b));

    return Perks(perks: perks);
  }

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
