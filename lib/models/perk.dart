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

const skillPointsPerLevel = 5;

class Perk {
  final int id;
  final String name;
  final int treeLevel;
  final String image;
  final Fl4kPerkType perkType;
  final int maxPoints;

  const Perk(
      {required this.id,
      required this.name,
      required this.treeLevel,
      required this.image,
      required this.perkType,
      required this.maxPoints});

  factory Perk.fromJson(dynamic json) {
    return Perk(
        id: json['id'],
        name: json['name'],
        treeLevel: json['treeLevel'],
        image: json['image'],
        perkType: parseFl4kPerkType(json['perkType']),
        maxPoints: json['maxPoints']);
  }

  bool isLocked(int usedPoints) {
    return usedPoints < skillPointsNeededToBeActivate();
  }

  bool canAddSkillPoint(int currentAssignedPoints) {
    if (perkType == Fl4kPerkType.actionSkill ||
        perkType == Fl4kPerkType.augment ||
        perkType == Fl4kPerkType.pet) {
      return false;
    }

    return currentAssignedPoints < maxPoints;
  }

  int skillPointsNeededToBeActivate() {
    if (treeLevel == 0) return 0;
    return (treeLevel - 1) * skillPointsPerLevel;
  }

  int compareTo(Perk other) {
    return treeLevel.compareTo(other.treeLevel);
  }

  @override
  bool operator ==(other) => other is Perk && id == other.id;

  @override
  int get hashCode => id.hashCode;
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
