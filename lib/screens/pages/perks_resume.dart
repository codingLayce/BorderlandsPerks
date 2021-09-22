import 'package:borderlands_perks/models/active_attribut.dart';
import 'package:borderlands_perks/models/attribut.dart';
import 'package:borderlands_perks/screens/components/attributs_viewer.dart';
import 'package:borderlands_perks/models/build.dart';
import 'package:borderlands_perks/services/build_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;

class PerksResume extends StatelessWidget {
  final Build buildRef;

  const PerksResume({required this.buildRef, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BuildManager>(builder: (context, state, child) {
      return Container(
          padding: const EdgeInsets.all(10),
          decoration:
              const BoxDecoration(color: app_colors.primaryBackgroundColor),
          child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(child: _buildResume(context))));
    });
  }

  _buildResume(BuildContext context) {
    return Flex(direction: Axis.vertical, children: [
      _spacing(),
      Text("${buildRef.name} Build - Attributes resume",
          style: Theme.of(context).textTheme.headline1),
      _spacing(),
      _attributs(AttributActivation.always),
      _spacing(),
      _attributs(AttributActivation.skill)
    ]);
  }

  _attributs(AttributActivation activation) {
    List<ActiveAttribut> attribs =
        _extractGivenActivation(buildRef.getActiveAttributs(), activation);

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
