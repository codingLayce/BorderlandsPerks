enum AttributUnitType {
  percentage,
  flat,
  seconds,
  dot,
  percentageDot,
  percentageStack,
  stack,
  percentagePerHit,
  percentageOfMissingHealth,
  precentageOfMaxHealth,
  percentageOfMaxHealthPerSeconds,
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
      case AttributUnitType.percentageStack:
        return "% per stack";
      case AttributUnitType.percentagePerHit:
        return "% per hit";
      case AttributUnitType.percentageOfMissingHealth:
        return "% of missing health";
      case AttributUnitType.precentageOfMaxHealth:
        return "% of max health";
      case AttributUnitType.percentageOfMaxHealthPerSeconds:
        return "% of max health per seconds";
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
    case "percentageStack":
      return AttributUnitType.percentageStack;
    case "percentagePerHit":
      return AttributUnitType.percentagePerHit;
    case "percentageOfMissingHealth":
      return AttributUnitType.percentageOfMissingHealth;
    case "precentageOfMaxHealth":
      return AttributUnitType.precentageOfMaxHealth;
    case "percentageOfMaxHealthPerSeconds":
      return AttributUnitType.percentageOfMaxHealthPerSeconds;
    default:
      return AttributUnitType.unknown;
  }
}

enum AttributActivation {
  skill,
  skillKill,
  always,
  firstPetAttack,
  petDealsDamage,
  enemyKill,
  shootingEnemy,
  petHealthAtValue,
  healthLow,
  reloading,
  skillEnd,
  petReviveFl4k,
  moving,
  still,
  aboveHalfHealth,
  dealDamageOnNotTargetingTarget,
  criticalHit,
  noEnemiesNearby,
  unknown
}

extension AttributActivationString on AttributActivation {
  String get name {
    switch (this) {
      case AttributActivation.skill:
        return "When Skill In Use";
      case AttributActivation.always:
        return "Always";
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
      case AttributActivation.shootingEnemy:
        return "When Shooting At Enemy";
      case AttributActivation.reloading:
        return "When Reloading";
      case AttributActivation.skillEnd:
        return "When Skill End";
      case AttributActivation.petReviveFl4k:
        return "When Pet Revive FL4K";
      case AttributActivation.moving:
        return "While Moving";
      case AttributActivation.still:
        return "While Not Moving";
      case AttributActivation.aboveHalfHealth:
        return "When Above Half Health";
      case AttributActivation.dealDamageOnNotTargetingTarget:
        return "When Dealing Damage On Target Who Are Not Targeting FL4K";
      case AttributActivation.criticalHit:
        return "When Scores A Critical Hit";
      case AttributActivation.noEnemiesNearby:
        return "When No Enemy Nearby";
      case AttributActivation.skillKill:
        return "When Hunter Skill Kill";
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
    case "shootingEnemy":
      return AttributActivation.shootingEnemy;
    case "reloading":
      return AttributActivation.reloading;
    case "skillEnd":
      return AttributActivation.skillEnd;
    case "petReviveFl4k":
      return AttributActivation.petReviveFl4k;
    case "moving":
      return AttributActivation.moving;
    case "still":
      return AttributActivation.still;
    case "aboveHalfHealth":
      return AttributActivation.aboveHalfHealth;
    case "dealDamageOnNotTargetingTarget":
      return AttributActivation.dealDamageOnNotTargetingTarget;
    case "criticalHit":
      return AttributActivation.criticalHit;
    case "noEnemiesNearby":
      return AttributActivation.noEnemiesNearby;
    case "skillKill":
      return AttributActivation.skillKill;
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
