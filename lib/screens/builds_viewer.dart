import 'package:borderlands_perks/models/character.dart';
import 'package:borderlands_perks/screens/character_viewer.dart';
import 'package:borderlands_perks/screens/components/add_build_dialog.dart';
import 'package:flutter/material.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;

class BuildsViewer extends StatefulWidget {
  const BuildsViewer({Key? key}) : super(key: key);

  @override
  State<BuildsViewer> createState() => _BuildsViewerState();
}

class _BuildsViewerState extends State<BuildsViewer> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: app_colors.primaryBackgroundColor,
        appBar: AppBar(title: const Text("Borderlands Perks")),
        body: loading ? const CircularProgressIndicator() : Container(),
        floatingActionButton: _getFloatingActionButton());
  }

  _getFloatingActionButton() {
    return FloatingActionButton(
        backgroundColor: app_colors.textAttributColor,
        foregroundColor: app_colors.textColor,
        tooltip: 'Add new build',
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return AddBuildDialog(callback: (name, character) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (context) =>
                            CharacterViewer(character: character, name: name)));
              });
            }));
  }
}
