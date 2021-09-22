import 'package:borderlands_perks/models/build.dart';
import 'package:borderlands_perks/models/character.dart';
import 'package:borderlands_perks/models/perks.dart';
import 'package:borderlands_perks/screens/components/perk_viewer.dart';
import 'package:flutter/material.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;

class PerksViewer extends StatefulWidget {
  final Character character;
  final Perks perks;
  final int tree;
  final Build build;

  const PerksViewer(
      {required this.character,
      required this.perks,
      required this.tree,
      required this.build,
      Key? key})
      : super(key: key);

  @override
  State createState() => _PerksViewer();
}

class _PerksViewer extends State<PerksViewer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: _getBackgroundColor()),
        child: Align(alignment: Alignment.center, child: _buildPerkTree()));
  }

  Widget _buildPerkTree() {
    Map<int, Widget> content = <int, Widget>{};

    widget.perks.getPerks().forEach((treeLevel, levelPerks) {
      content[treeLevel] = SizedBox(
          height: 100,
          child: Row(
              children: List.generate(
                  levelPerks.length,
                  (index) => PerkViewer(
                      perk: levelPerks[index],
                      tree: widget.tree,
                      build: widget.build))));
    });

    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(content.length,
                (index) => content.entries.elementAt(index).value)));
  }

  Color _getBackgroundColor() {
    switch (widget.tree) {
      case 0:
        return app_colors.firstTreeColor;
      case 1:
        return app_colors.secondTreeColor;
      case 2:
        return app_colors.thirdTreeColor;
      case 3:
        return app_colors.fourthTreeColor;
      default:
        return app_colors.primaryBackgroundColor;
    }
  }
}
