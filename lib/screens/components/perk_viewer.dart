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
                showDialog(
                    context: context,
                    builder: (context) => Popover(perk: perk, state: state));
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
    return SimpleDialog(
        titlePadding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.all(10),
        title: _name(context),
        children: [
          _type(context),
          _separator(),
          _description(context),
          _separator(),
          _currentAttributs(context),
          _separator(),
          _nextAttributs(context)
        ]);
  }

  _displayAttributs(BuildContext context, String title, bool next) {
    List<Widget> widgets = [];

    if (title != "") {
      widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(title,
                  style: const TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: app_colors.textColor)))));
    }

    for (var attrib in perk.attributs) {
      widgets.add(Align(
          alignment: Alignment.centerLeft,
          child: RichText(
              text: TextSpan(children: [
            TextSpan(
                text: attrib.name,
                style: const TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: app_colors.textAttributColor)),
            TextSpan(
                text: ": ${_getValues(state, attrib, next)}",
                style: Theme.of(context).textTheme.bodyText1)
          ]))));
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start, children: widgets);
  }

  _currentAttributs(BuildContext context) {
    if (perk.perkType == Fl4kPerkType.passive) {
      if (state.isSelected(perk.id)) {
        return _displayAttributs(context, "Current Level Bonus", false);
      }
      return _displayAttributs(context, "Level Bonus", false);
    }
    return _displayAttributs(context, "", false);
  }

  _nextAttributs(BuildContext context) {
    if (perk.perkType == Fl4kPerkType.passive &&
        state.isSelected(perk.id) &&
        state.getAssignedPoints(perk) < perk.maxPoints) {
      return _displayAttributs(context, "Next Level Bonus", true);
    }
    return Container();
  }

  String _getValues(PerksManager state, Attribut attrib, bool next) {
    if (attrib.values.length == 1) {
      return _getFirstAttribValue(attrib);
    }

    if (state.isSelected(perk.id)) {
      if (next) {
        return _getNextAttribValue(state, attrib);
      }
      return _getCurrentAttribValue(state, attrib);
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
    String val = "${attrib.values[0]} ${attrib.unit.ext}";
    return _checkAndFormatPositivePercentage(
        val, attrib.unit, attrib.values[0]);
  }

  String _getCurrentAttribValue(PerksManager state, Attribut attrib) {
    int level = state.getAssignedPoints(perk);
    String val = "${attrib.values[level - 1]} ${attrib.unit.ext}";
    return _checkAndFormatPositivePercentage(
        val, attrib.unit, attrib.values[level - 1]);
  }

  String _getNextAttribValue(PerksManager state, Attribut attrib) {
    int level = state.getAssignedPoints(perk);
    String val = "${attrib.values[level]} ${attrib.unit.ext}";
    return _checkAndFormatPositivePercentage(
        val, attrib.unit, attrib.values[level]);
  }

  String _checkAndFormatPositivePercentage(
      String val, AttributUnitType unit, num value) {
    if (unit == AttributUnitType.percentage && value > 0) {
      return "+$val";
    }
    return val;
  }

  _separator() {
    return const Divider();
  }

  _description(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Column(
            children: List.generate(
                perk.description.length,
                (index) => Text(perk.description[index],
                    textAlign: TextAlign.justify,
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
