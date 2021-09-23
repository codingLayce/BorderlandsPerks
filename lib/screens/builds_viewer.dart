import 'package:borderlands_perks/models/build.dart';
import 'package:borderlands_perks/screens/build_viewer.dart';
import 'package:borderlands_perks/screens/components/add_build_dialog.dart';
import 'package:borderlands_perks/screens/components/zoom_animation_wrapper.dart';
import 'package:borderlands_perks/services/build_manager.dart';
import 'package:flutter/material.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;
import 'package:provider/provider.dart';
import 'package:borderlands_perks/models/character.dart';
import 'package:uuid/uuid.dart';

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
        body: loading ? const CircularProgressIndicator() : _getBuildList(),
        floatingActionButton: _getFloatingActionButton());
  }

  _getBuildList() {
    return Consumer<BuildManager>(builder: (context, state, child) {
      if (!state.buildsRetrieved) {
        state.loadBuildsFromStorage();
      }

      return state.buildsRetrieved
          ? Container(
              width: double.infinity,
              margin: const EdgeInsets.all(15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _getBuildWidgets(context, state)))
          : const Center(
              child: CircularProgressIndicator(
                  color: app_colors.textAttributColor));
    });
  }

  _getBuildWidgets(BuildContext context, BuildManager state) {
    return List.generate(state.builds.length, (index) {
      Build build = state.getBuild(index);
      return ZoomAnimationWrapper(
          disableDoubleTap: true,
          onLongPress: () => showDialog(
              context: context,
              builder: (context) => _getConfirmDeleteDialog(context, build, () {
                    state.removeBuild(build);
                  })),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (context) => BuildViewer(build: build))),
          child: Container(
              width: double.infinity,
              height: 64,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(bottom: 10),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: Row(children: [
                Image.asset(build.character.iconPath),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(build.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline1)),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "${build.skillPoints}",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: build.skillPoints == 0
                              ? Colors.red
                              : app_colors.textAttributColor)),
                  TextSpan(
                      text: " / ${build.maxSkillPoints}",
                      style: const TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black))
                ]))
              ])));
    });
  }

  Widget _getConfirmDeleteDialog(
      BuildContext context, Build build, Function() callback) {
    return AlertDialog(
        title: const Text("Supprimer Build"),
        content: RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.bodyText1,
                children: [
              const TextSpan(
                  text: "Etes vous sur de vouloir supprimer le build \""),
              TextSpan(
                  text: build.name, style: Theme.of(context).textTheme.caption),
              const TextSpan(text: "\" ?")
            ])),
        actions: [
          TextButton(
              child: const Text("NON", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context)),
          TextButton(
              child: const Text("OUI",
                  style: TextStyle(color: app_colors.textAttributColor)),
              onPressed: () {
                Navigator.pop(context);
                callback();
              })
        ]);
  }

  _getFloatingActionButton() {
    return Consumer<BuildManager>(builder: (context, state, child) {
      return FloatingActionButton(
          backgroundColor: app_colors.textAttributColor,
          foregroundColor: app_colors.textColor,
          tooltip: 'Add new build',
          child: const Icon(Icons.add),
          onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return AddBuildDialog(callback: (name, character) {
                  Build build = Build(
                      name: name, character: character, id: const Uuid().v1());
                  state.addBuild(build);

                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (context) => BuildViewer(build: build)));
                });
              }));
    });
  }
}
