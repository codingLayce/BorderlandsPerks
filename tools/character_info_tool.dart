import 'dart:convert';
import 'dart:io';

import 'package:borderlands_perks/models/character.dart';

void main() {
  var line;

  stdout.write("Perks Creation Tool !\n");
  stdout.write("Type 'quit' at anytime to exit !\n");

  do {
    line = stdin.readLineSync();
  } while (line != "quit");
}

class Attribut {
  final String name;
  final String unit;
  final List<dynamic> values;
  final String activation;

  Attribut(this.name, this.unit, this.values, this.activation);

  Map toJson() {
    return {
      "name": name,
      "unit": unit,
      "values": jsonEncode(values),
      "activation": activation
    };
  }
}

class Perk {
  late String id;
  late String name;
  late int treeLevel;
  late String image;
  late String perkType;
  late int maxPoints;
  late List<String> description;
  late List<Attribut> attributs;

  final Character character;
  final String treeName;

  Perk(this.character, this.treeName);

  askName() {
    var line = stdin.readLineSync();
    if (line == "quit") {
      return null;
    }

    name = line!;
    image =
        "assets/B3/${character.name}/$treeName/images/${line.replaceAll(" ", "")}.png";
    if (!File("../$image").existsSync()) {
      stderr.write("Image $image non trouvée !\n");
      return null;
    }

    return askTreeLevel;
  }

  askTreeLevel() {
    var line = stdin.readLineSync();
    if (line == "quit") {
      return null;
    }

    if (line != null && line is int) {
      treeLevel = line;
    }
  }
}
