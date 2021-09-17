enum AttributUnitType {
  percentage,
  flat,
  seconds,
  dot,
  percentageDot,
  stack,
  unknown
}

extension AttributUnitTypeTerminaison on AttributUnitType {
  String get ext {
    switch (this) {
      case AttributUnitType.percentage:
        return "%";
      case AttributUnitType.seconds:
        return "s";
      case AttributUnitType.dot:
        return "per seconds";
      case AttributUnitType.percentageDot:
        return "% per seconds";
      default:
        return "";
    }
  }
}

AttributUnitType parseAttributUnitType(String value) {
  switch (value) {
    case "percentage":
      return AttributUnitType.percentage;
    case "flat":
      return AttributUnitType.flat;
    case "seconds":
      return AttributUnitType.seconds;
    case "dot":
      return AttributUnitType.dot;
    case "stack":
      return AttributUnitType.stack;
    case "percentageDot":
      return AttributUnitType.percentageDot;
    default:
      return AttributUnitType.unknown;
  }
}

enum AttributActivation {
  skill,
  always,
  firstPetAttack,
  petDealsDamage,
  enemyKill,
  petHealthAtValue,
  healthLow,
  unknown
}

extension AttributActivationString on AttributActivation {
  String get name {
    switch (this) {
      case AttributActivation.skill:
        return "When Skill In Use";
      case AttributActivation.always:
        return "Always ";
      case AttributActivation.firstPetAttack:
        return "On First Pet Attack";
      case AttributActivation.petDealsDamage:
        return "When Pet Deals Damage";
      case AttributActivation.enemyKill:
        return "When Killing An Enemy";
      case AttributActivation.petHealthAtValue:
        return "When Pet Health Is At Value";
      case AttributActivation.healthLow:
        return "When Low Health";
      default:
        return "";
    }
  }
}

AttributActivation parseAttributActivation(String value) {
  switch (value) {
    case "skill":
      return AttributActivation.skill;
    case "always":
      return AttributActivation.always;
    case "firstPetAttack":
      return AttributActivation.firstPetAttack;
    case "petDealsDamage":
      return AttributActivation.petDealsDamage;
    case "enemyKill":
      return AttributActivation.enemyKill;
    case "petHealthAtValue":
      return AttributActivation.petHealthAtValue;
    case "healthLow":
      return AttributActivation.healthLow;
    default:
      return AttributActivation.unknown;
  }
}

class Attribut {
  final String name;
  final AttributUnitType unit;
  final List<dynamic> values;
  final AttributActivation activation;

  const Attribut(
      {required this.name,
      required this.unit,
      required this.values,
      required this.activation});

  factory Attribut.fromJson(dynamic json) {
    return Attribut(
        name: json['name'],
        unit: parseAttributUnitType(json['unit']),
        activation: parseAttributActivation(json['activation']),
        values: json['values'] as List<dynamic>);
  }

  @override
  bool operator ==(other) => other is Attribut && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
