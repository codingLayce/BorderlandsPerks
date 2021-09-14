import 'package:borderlands_perks/models/perk.dart';
import 'package:borderlands_perks/services/perks_manager.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class PerkViewer extends StatelessWidget {
  final Perk perk;

  const PerkViewer({required this.perk, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PerksManager>(builder: (context, state, child) {
      return Expanded(
          child: GestureDetector(
              onTap: () {
                state.assignSkillPoint(perk);
              },
              onDoubleTap: () {
                state.removeSkillPoint(perk);
              },
              onLongPress: () {
                showPopover(
                    context: context,
                    transitionDuration: const Duration(milliseconds: 150),
                    direction: PopoverDirection.top,
                    width: 250,
                    height: 250,
                    bodyBuilder: (context) => Popover(perk: perk));
              },
              child:
                  state.isSelected(perk) ? _colorizedImage() : _normalImage()));
    });
  }

  _colorizedImage() {
    return ColorFiltered(
        colorFilter:
            const ColorFilter.mode(Colors.lightGreenAccent, BlendMode.modulate),
        child: Image.asset(perk.image));
  }

  _normalImage() {
    return Image.asset(perk.image);
  }
}

class Popover extends StatelessWidget {
  final Perk perk;

  const Popover({required this.perk, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(perk.name, style: Theme.of(context).textTheme.headline1),
      Text(perk.perkType.text, style: Theme.of(context).textTheme.bodyText1)
    ]);
  }
}
