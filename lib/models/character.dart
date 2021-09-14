enum Character { fl4k, amara, moze, zane }

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
