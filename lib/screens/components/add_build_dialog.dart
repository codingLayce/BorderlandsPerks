import 'package:borderlands_perks/models/character.dart';
import 'package:flutter/material.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;

typedef PostFormFunc = void Function(String name, Character character);

class AddBuildDialog extends StatefulWidget {
  final PostFormFunc callback;

  const AddBuildDialog({required this.callback, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddBuildDialog();
}

class _AddBuildDialog extends State<AddBuildDialog> {
  final TextEditingController _controller = TextEditingController();
  Character _currentSelectedValue = Character.fl4k;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Create new build",
          style: Theme.of(context).textTheme.headline1),
      contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      titlePadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      children: [_content(context)],
    );
  }

  _content(BuildContext context) {
    return Wrap(runSpacing: 5.0, children: [
      Flex(direction: Axis.horizontal, children: [
        Expanded(flex: 8, child: _getNameLabel()),
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(flex: 16, child: _getNameField())
      ]),
      Flex(direction: Axis.horizontal, children: [
        Expanded(flex: 8, child: _getCharacterLabel()),
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(flex: 16, child: _getCharacterDropdown(context))
      ]),
      Row(children: [Expanded(child: _getErrorField())]),
      Row(children: [Expanded(child: _getRegisterButton())])
    ]);
  }

  _getRegisterButton() {
    return TextButton(
        onPressed: () {
          if (_controller.value.text == "") {
            setState(() {
              error = "Build name empty";
            });
            return;
          }
          if (_currentSelectedValue == Character.none) {
            setState(() {
              error = "Character empty";
            });
            return;
          }
          error = "";
          widget.callback(_controller.value.text, _currentSelectedValue);
        },
        child: const Text("Enregistrer",
            style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: app_colors.textAttributColor)));
  }

  _getErrorField() {
    return Text(error,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontFamily: "Roboto",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.red));
  }

  _getCharacterDropdown(BuildContext context) {
    return SizedBox(
        height: 70,
        child: InputDecorator(
          decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.bodyText1,
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.black, width: 2.0)),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                      color: app_colors.textAttributColor, width: 2.0))),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Character>(
              value: _currentSelectedValue,
              isDense: true,
              onChanged: (newValue) {
                setState(() {
                  _currentSelectedValue = newValue!;
                });
              },
              items: Character.values
                  .where((character) => character != Character.none)
                  .map((value) {
                return DropdownMenuItem<Character>(
                  value: value,
                  child: Text(value.name,
                      style: Theme.of(context).textTheme.bodyText1),
                );
              }).toList(),
            ),
          ),
        ));
  }

  _getCharacterLabel() {
    return Container(
        height: 70,
        padding: const EdgeInsets.all(5),
        child: Center(
            child: Text("Character :",
                style: Theme.of(context).textTheme.bodyText1)));
  }

  _getNameLabel() {
    return Container(
        height: 50,
        padding: const EdgeInsets.all(5),
        child: Center(
            child:
                Text("Name :", style: Theme.of(context).textTheme.bodyText1)));
  }

  _getNameField() {
    return SizedBox(
        height: 50,
        child: Center(
            child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context).textTheme.bodyText1,
                cursorColor: Colors.black,
                autofocus: false,
                cursorHeight: 20.0,
                cursorWidth: 1.0,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: -5, horizontal: 5),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(
                            color: app_colors.textAttributColor, width: 2.0)),
                    hintText: "Build name"),
                controller: _controller)));
  }
}
