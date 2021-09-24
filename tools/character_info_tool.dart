import 'dart:convert';
import 'dart:io';

enum Character { fl4k, amara, moze, zane, none }

extension CharacterString on Character {
  String get name {
    switch (this) {
      case Character.fl4k:
        return "FL4K";
      case Character.amara:
        return "AMARA";
      case Character.moze:
        return "MOZE";
      case Character.zane:
        return "ZANE";
      case Character.none:
        return "";
    }
  }
}

Character parseCharacter(String value) {
  switch (value.toUpperCase()) {
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

void main() {
  stdout.write("Perks Creation Tool !\n");
  stdout.write("Type 'quit' at anytime to exit !\n");

  stdout.write("\nPersonnage: ");
  var line = stdin.readLineSync();
  Character character = parseCharacter(line!);

  if (character == Character.none) {
    stderr.write("Unknown character !\n");
    exit(-1);
  }

  stdout.write("Tree name: ");
  var name = stdin.readLineSync();

  List<Perk> perks = [];

  do {
    stdout.write("\nAdd a new perk ? [y,n] ");
    line = stdin.readLineSync();

    if (line!.toLowerCase() == 'y') {
      try {
        Perk? perk = Perk.build(character, name!, perks.length);

        if (perk == null) {
          stdout.write("'quit' detected. Leaving the tool !\n");
          exit(0);
        }

        perks.add(perk);
        stdout.write("Perk added to the list !\n");
      } on Exception catch (e) {
        stderr.write(e.toString());
        exit(-1);
      }
    }
  } while (line.toLowerCase() == 'y' || line.toLowerCase() == 'yes');

  stdout.write("\nSaving skill tree...\n");

  var file = File("../assets/B3/${character.name}/$name/info.json");
  if (!file.existsSync()) {
    file.createSync();
  }
  var sink = file.openWrite();
  sink.write(jsonEncode(perks));
  sink.close();

  stdout.write("Saved !\n");
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
      "values": values,
      "activation": activation
    };
  }

  @override
  String toString() {
    return "$name, $unit, $activation, $values";
  }

  static Attribut? build() {
    stdout.write("\t\tName: ");
    var name = stdin.readLineSync();
    if (name == null) {
      return null;
    }

    stdout.write("\t\tUnit: ");
    var unit = stdin.readLineSync();
    if (unit == null) {
      return null;
    }

    stdout.write("\t\tActivation: ");
    var activation = stdin.readLineSync();
    if (activation == null) {
      return null;
    }

    stdout.write("\t\tValues (separated by a space ' '): ");
    var valuesEntered = stdin.readLineSync();

    var splited = valuesEntered!.split(" ");
    List<dynamic> values = splited.map((e) {
      var val = int.tryParse(e);
      if (val != null) {
        return val;
      }
      return double.tryParse(e);
    }).toList();

    return Attribut(name, unit, values, activation);
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

  Perk(this.character, this.treeName, this.id);

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'treeLevel': treeLevel,
      'image': image,
      'perkType': perkType,
      'maxPoints': maxPoints,
      'description': description,
      'attributs': attributs
    };
  }

  @override
  String toString() {
    return "$id, $name, $treeLevel, $image, $perkType, $maxPoints, $description, $attributs";
  }

  static Perk? build(Character character, String treeName, int num) {
    return askName(Perk(character, treeName,
        "${character.name.substring(0, 1)}_${treeName}_$num"));
  }

  static Perk? askName(Perk perk) {
    stdout.write("----- New perk -----\n");
    stdout.write("\tName: ");
    var line = stdin.readLineSync();
    if (line == "quit") {
      return null;
    }

    perk.name = line!;
    perk.image =
        "assets/B3/${perk.character.name}/${perk.treeName}/images/${line.replaceAll(" ", "")}.png";
    if (!File("../${perk.image}").existsSync()) {
      throw Exception("Image ${perk.image} non trouvée !\n");
    }

    return askTreeLevel(perk);
  }

  static Perk? askTreeLevel(Perk perk) {
    stdout.write("\tTreeLevel: ");
    var line = stdin.readLineSync();
    if (line == "quit") {
      return null;
    }

    perk.treeLevel = int.tryParse(line!) ?? -1;

    if (perk.treeLevel < 0) {
      throw Exception("Cannot convert $line to int or $line is negative !");
    }

    return askPerkType(perk);
  }

  static Perk? askPerkType(Perk perk) {
    stdout.write("\tPerk Type: ");
    var line = stdin.readLineSync();
    if (line == "quit") {
      return null;
    }

    perk.perkType = line!;

    return askPerkMaxPoints(perk);
  }

  static Perk? askPerkMaxPoints(Perk perk) {
    stdout.write("\tMax Points: ");
    var line = stdin.readLineSync();
    if (line == "quit") {
      return null;
    }

    perk.maxPoints = int.tryParse(line!) ?? -1;

    if (perk.maxPoints < 0) {
      throw Exception("Cannot convert $line to int or $line is negative !");
    }

    return askPerkDescription(perk);
  }

  static Perk? askPerkDescription(Perk perk) {
    stdout.write("\tDescription (enter for each line): ");

    perk.description = [];

    String? line;
    do {
      line = stdin.readLineSync();
      if (line != null && line != '') {
        perk.description.add(line);
      }
    } while (line != null && line != '');

    if (perk.description.isEmpty) {
      throw Exception("No description provided !");
    }

    return askPerkAttributes(perk);
  }

  static Perk? askPerkAttributes(Perk perk) {
    perk.attributs = [];

    String? line;
    do {
      stdout.write("\tAdd a new attribute ? [y,n] ");
      line = stdin.readLineSync();

      if (line!.toLowerCase() == 'y') {
        try {
          Attribut? attrib = Attribut.build();

          if (attrib == null) {
            return null;
          }

          perk.attributs.add(attrib);
          stdout.write("\tAttrib added to the list !\n");
        } on Exception catch (e) {
          stderr.write(e.toString());
          exit(-1);
        }
      }
    } while (line.toLowerCase() == 'y' || line.toLowerCase() == 'yes');

    return perk;
  }
}
