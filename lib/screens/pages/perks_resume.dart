import 'package:borderlands_perks/models/active_attribut.dart';
import 'package:borderlands_perks/models/attribut.dart';
import 'package:borderlands_perks/models/character.dart';
import 'package:borderlands_perks/screens/components/attributs_viewer.dart';
import 'package:borderlands_perks/services/perks_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;

class PerksResume extends StatelessWidget {
  final Character character;

  const PerksResume({required this.character, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PerksManager>(builder: (context, state, child) {
      return Container(
          decoration:
              const BoxDecoration(color: app_colors.primaryBackgroundColor),
          child: Align(
              alignment: Alignment.center,
              child: _buildResume(context, state)));
    });
  }

  _buildResume(BuildContext context, PerksManager state) {
    return Flex(direction: Axis.vertical, children: [
      _spacing(),
      Text("${character.name}'s Build - Attributes resume",
          style: Theme.of(context).textTheme.headline1),
      _spacing(),
      _attributs(state, AttributActivation.always),
      _spacing(),
      _attributs(state, AttributActivation.skill)
    ]);
  }

  _attributs(PerksManager state, AttributActivation activation) {
    List<ActiveAttribut> attribs =
        _extractGivenActivation(state.getActiveAttributs(), activation);

    if (attribs.isEmpty) {
      return Container();
    }

    return AttributsViewer(attribs: attribs, activation: activation);
  }

  _spacing() {
    return const SizedBox(height: 15);
  }

  List<ActiveAttribut> _extractGivenActivation(
      List<ActiveAttribut> attribs, AttributActivation activation) {
    return attribs
        .where((element) => element.activation == activation)
        .toList();
  }
}
