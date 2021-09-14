enum Fl4kPerkType { actionSkill, pet, augment, passive, unknown }

extension Fl4kPerkTypeString on Fl4kPerkType {
  String get text {
    switch (this) {
      case Fl4kPerkType.actionSkill:
        return "Action Skill";
      case Fl4kPerkType.pet:
        return "Pet";
      case Fl4kPerkType.augment:
        return "Augment";
      case Fl4kPerkType.passive:
        return "Passive";
      default:
        return "Unknown";
    }
  }
}

class Perk {
  final String name;
  final int treeLevel;
  final String image;
  final Fl4kPerkType perkType;

  const Perk(
      {required this.name,
      required this.treeLevel,
      required this.image,
      required this.perkType});

  factory Perk.fromJson(dynamic json) {
    return Perk(
        name: json['name'],
        treeLevel: json['treeLevel'],
        image: json['image'],
        perkType: parseFl4kPerkType(json['perkType']));
  }

  int compareTo(Perk other) {
    return treeLevel.compareTo(other.treeLevel);
  }

  @override
  String toString() {
    return "$name $treeLevel $image";
  }

  @override
  bool operator ==(other) =>
      other is Perk &&
      name == other.name &&
      treeLevel == other.treeLevel &&
      image == other.image &&
      perkType == other.perkType;

  @override
  int get hashCode => name.hashCode;
}

Fl4kPerkType parseFl4kPerkType(String value) {
  switch (value) {
    case "ActionSkill":
      return Fl4kPerkType.actionSkill;
    case "Pet":
      return Fl4kPerkType.pet;
    case "Augment":
      return Fl4kPerkType.augment;
    case "Passive":
      return Fl4kPerkType.passive;
    default:
      return Fl4kPerkType.unknown;
  }
}
