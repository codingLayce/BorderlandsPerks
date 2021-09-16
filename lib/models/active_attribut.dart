import 'package:borderlands_perks/models/attribut.dart';

class ActiveAttribut {
  final String name;
  final AttributUnitType unit;
  final dynamic value;
  final AttributActivation activation;

  const ActiveAttribut(
      {required this.name,
      required this.unit,
      required this.value,
      required this.activation});
}
