enum Character { fl4k, amara, moze, zane }

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
    }
  }
}

extension CharacterLoader on Character {
  List<String> getPaths() {
    String path = "assets/B3";
    switch (this) {
      case Character.fl4k:
        path = "$path/FL4K";
        break;
      default:
        return [];
    }

    return ["$path/Master/info.json"];
  }
}
