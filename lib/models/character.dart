import 'package:borderlands_perks/models/perks.dart';

enum Character { fl4k, amara, moze, zane }

extension CharacterLoader on Character {
  Future<Perks> loadTree(int index) async {
    String path = "assets/B3";
    switch (this) {
      case Character.fl4k:
        path = "$path/FL4K";
        break;
      default:
        return Future.error("Unknown character");
    }

    switch (index) {
      case 1:
        path = "$path/Master/info.json";
        break;
      default:
        return Future.error("No data for that skills tree");
    }

    return Perks.load(path);
  }
}
