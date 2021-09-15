enum AttributUnitType { percentage, flat, seconds, unknown }

extension AttributUnitTypeTerminaison on AttributUnitType {
  String get ext {
    switch (this) {
      case AttributUnitType.percentage:
        return "%";
      case AttributUnitType.seconds:
        return "s";
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
    default:
      return AttributUnitType.unknown;
  }
}

class Attribut {
  final String name;
  final AttributUnitType unit;
  final List<dynamic> values;

  const Attribut(
      {required this.name, required this.unit, required this.values});

  factory Attribut.fromJson(dynamic json) {
    return Attribut(
        name: json['name'],
        unit: parseAttributUnitType(json['unit']),
        values: json['values'] as List<dynamic>);
  }
}
