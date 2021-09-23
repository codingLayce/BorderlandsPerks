enum Character { fl4k, amara, moze, zane, none }

extension CharacterIcon on Character {
  String get iconPath {
    switch (this) {
      case Character.fl4k:
        return "assets/B3/FL4K/icon.png";
      case Character.amara:
        return "assets/B3/AMARA/icon.png";
      case Character.moze:
        return "assets/B3/MOZE/icon.png";
      case Character.zane:
        return "assets/B3/ZANE/icon.png";
      case Character.none:
        return "assets/B3/FL4K/icon.png";
    }
  }
}

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

    return [
      "$path/Master/info.json",
      "$path/Stalker/info.json",
      "$path/Hunter/info.json",
      "$path/Trapper/info.json"
    ];
  }
}
