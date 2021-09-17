import 'package:borderlands_perks/models/active_attribut.dart';
import 'package:borderlands_perks/models/attribut.dart';
import 'package:flutter/material.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;

class AttributsViewer extends StatefulWidget {
  final List<ActiveAttribut> attribs;
  final AttributActivation activation;

  const AttributsViewer(
      {required this.attribs, required this.activation, Key? key})
      : super(key: key);

  @override
  State<AttributsViewer> createState() => _AttributsViewerState();
}

class _AttributsViewerState extends State<AttributsViewer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    widgets.add(Row(children: [
      Expanded(
          child: Text("Activation: ${widget.activation.name}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1)),
      Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down)
    ]));

    if (isExpanded) {
      widgets.add(const Divider());

      for (var attrib in widget.attribs) {
        widgets.add(Flex(direction: Axis.horizontal, children: [
          Expanded(
              flex: 5,
              child: Text(attrib.name,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: app_colors.textAttributColor))),
          Expanded(
              flex: 4,
              child: Text(
                  " : ${_checkAndFormatPositivePercentage("${attrib.value} ${attrib.unit.ext}", attrib.unit, attrib.value)}",
                  style: Theme.of(context).textTheme.bodyText1))
        ]));
      }
    }

    return GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1)),
            child: Column(children: widgets)));
  }

  String _checkAndFormatPositivePercentage(
      String val, AttributUnitType unit, num value) {
    if (unit == AttributUnitType.percentage && value > 0) {
      return "+$val";
    }
    return val;
  }
}
