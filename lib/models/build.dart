import 'package:borderlands_perks/models/character.dart';
import 'package:borderlands_perks/services/perks_manager.dart';

class Build {
  final List<PerksManager> manager;
  final String name;
  final Character character;

  const Build(
      {required this.manager, required this.name, required this.character});
}
