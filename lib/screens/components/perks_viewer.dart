import 'package:borderlands_perks/models/character.dart';
import 'package:borderlands_perks/models/perks.dart';
import 'package:borderlands_perks/screens/components/perk_viewer.dart';
import 'package:flutter/material.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;

class PerksViewer extends StatefulWidget {
  final Character character;
  final int tree;

  const PerksViewer({required this.character, required this.tree, Key? key})
      : super(key: key);

  @override
  State createState() => _PerksViewer();
}

class _PerksViewer extends State<PerksViewer> {
  late Perks perks;
  bool loading = true;
  String error = "";

  @override
  void initState() {
    super.initState();
    loadPerks();
  }

  void loadPerks() async {
    widget.character.loadTree(widget.tree).then((value) {
      perks = value;
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        perks = Perks(perks: []);
        loading = false;
        this.error = error.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: _getBackgroundColor()),
        child: Align(
            alignment: Alignment.center,
            child: loading
                ? const CircularProgressIndicator()
                : _getErrorOrPerkTree()));
  }

  Widget _getErrorOrPerkTree() {
    if (!loading && error == "") return _buildPerkTree();
    return _buildError();
  }

  Widget _buildError() {
    return Center(
        child: Text("Error: $error",
            style: const TextStyle(
                fontFamily: "Roboto",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.red)));
  }

  Widget _buildPerkTree() {
    Map<int, Widget> content = <int, Widget>{};

    perks.getPerks().forEach((treeLevel, levelPerks) {
      content[treeLevel] = SizedBox(
          height: 100,
          child: Row(
              children: List.generate(levelPerks.length,
                  (index) => PerkViewer(perk: levelPerks[index]))));
    });

    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(content.length,
                (index) => content.entries.elementAt(index).value)));
  }

  Color _getBackgroundColor() {
    switch (widget.tree) {
      case 1:
        return app_colors.firstTreeColor;
      case 2:
        return app_colors.secondTreeColor;
      case 3:
        return app_colors.thirdTreeColor;
      case 4:
        return app_colors.fourthTreeColor;
      default:
        return app_colors.primaryBackgroundColor;
    }
  }
}
