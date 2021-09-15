import 'package:borderlands_perks/models/perk.dart';
import 'package:borderlands_perks/screens/components/error.dart';
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
                String error = state.assignSkillPoint(perk);
                if (error != "") {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(Error.getSnackBar(context, error));
                }
              },
              onDoubleTap: () {
                if (!state.removeSkillPoint(perk)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Error(
                          error: "Cannot remove skill point on that perk")));
                }
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
              child: _perk(state)));
    });
  }

  _perk(PerksManager state) {
    return Column(children: [
      state.isSelected(perk.id) ? _selectedPerk() : _notSelectedPerk(state),
      const SizedBox(height: 5),
      RichText(
          text: TextSpan(children: [
        TextSpan(
            text: "${state.getAssignedPoints(perk)} ",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: state.getAssignedPoints(perk) == 0
                    ? Colors.red
                    : state.getAssignedPoints(perk) == perk.maxPoints
                        ? Colors.green
                        : Colors.white)),
        TextSpan(text: "/ ${perk.maxPoints}")
      ]))
    ]);
  }

  _selectedPerk() {
    return ColorFiltered(
        colorFilter:
            const ColorFilter.mode(Colors.lightGreenAccent, BlendMode.modulate),
        child: Image.asset(perk.image));
  }

  _notSelectedPerk(PerksManager state) {
    if (state.isPerkLocked(perk)) {
      return ColorFiltered(
          colorFilter: const ColorFilter.mode(
              Color.fromRGBO(100, 100, 100, 0.6), BlendMode.modulate),
          child: Image.asset(perk.image));
    }

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
