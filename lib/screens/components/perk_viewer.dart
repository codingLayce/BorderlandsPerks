import 'package:borderlands_perks/models/perk.dart';
import 'package:borderlands_perks/screens/components/zoom_animation_wrapper.dart';
import 'package:borderlands_perks/screens/components/error.dart';
import 'package:borderlands_perks/services/perks_manager.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;
import 'package:borderlands_perks/models/attribut.dart';

class PerkViewer extends StatelessWidget {
  final Perk perk;

  const PerkViewer({required this.perk, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PerksManager>(builder: (context, state, child) {
      return Expanded(
          child: ZoomAnimationWrapper(
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
                    width: 300,
                    height: 300,
                    bodyBuilder: (context) =>
                        Popover(perk: perk, state: state));
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
  final PerksManager state;

  const Popover({required this.perk, required this.state, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          _name(context),
          _spacing(),
          _type(context),
          _separator(),
          _description(context),
          _separator(),
          _currentAttributs(context),
          _separator()
        ]));
  }

  _currentAttributs(BuildContext context) {
    int length = perk.attributs.length;
    bool isPassive = perk.perkType == Fl4kPerkType.passive;

    if (isPassive) {
      ++length;
    }

    Widget widget = Column(
        mainAxisAlignment:
            isPassive ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: List.generate(length, (index) {
          int accessor = index;
          if (isPassive) {
            --accessor;
          }

          if (isPassive && index == 0) {
            return const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Current Level Bonus",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: app_colors.textColor))));
          }
          return Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: perk.attributs[accessor].name,
                    style: const TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: app_colors.textAttributColor)),
                TextSpan(
                    text: ": ${_getValues(state, perk.attributs[accessor])}",
                    style: Theme.of(context).textTheme.bodyText1)
              ])));
        }));

    if (isPassive) {
      return widget;
    }

    return Expanded(child: widget);
  }

  String _getValues(PerksManager state, Attribut attrib) {
    if (state.isSelected(perk.id)) {
      return _getCurrentAttribValue(state, attrib);
    }

    if (attrib.values.length == 1) {
      return _getFirstAttribValue(attrib);
    }

    return _getAttribValues(attrib);
  }

  String _getAttribValues(Attribut attrib) {
    var buffer = StringBuffer();

    buffer.write("[");
    for (int i = 0; i < attrib.values.length; i++) {
      if (attrib.unit == AttributUnitType.percentage && attrib.values[i] > 0) {
        buffer.write("+");
      }
      buffer.write(attrib.values[i]);
      buffer.write(attrib.unit.ext);
      if (i < attrib.values.length - 1) {
        buffer.write(", ");
      }
    }
    buffer.write("]");

    return buffer.toString();
  }

  String _getFirstAttribValue(Attribut attrib) {
    return "${attrib.values[0]} ${attrib.unit.ext}";
  }

  String _getCurrentAttribValue(PerksManager state, Attribut attrib) {
    int level = state.getAssignedPoints(perk);
    return "${attrib.values[level - 1]} ${attrib.unit.ext}";
  }

  _separator() {
    return const Divider();
  }

  _spacing() {
    return const SizedBox(height: 5);
  }

  _description(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Column(
            children: List.generate(
                perk.description.length,
                (index) => Text(perk.description[index],
                    style: Theme.of(context).textTheme.bodyText1))));
  }

  _type(BuildContext context) {
    return Text(perk.perkType.text,
        style: Theme.of(context).textTheme.bodyText1);
  }

  _name(BuildContext context) {
    return Text(perk.name, style: Theme.of(context).textTheme.headline1);
  }
}
