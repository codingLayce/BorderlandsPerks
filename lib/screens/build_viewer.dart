import 'package:borderlands_perks/models/perks.dart';
import 'package:borderlands_perks/screens/components/global_perks.dart';
import 'package:borderlands_perks/screens/pages/perks_resume.dart';
import 'package:borderlands_perks/screens/pages/perks_viewer.dart';
import 'package:borderlands_perks/models/build.dart';
import 'package:borderlands_perks/services/build_manager.dart';
import 'package:flutter/material.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class BuildViewer extends StatefulWidget {
  final Build build;

  const BuildViewer({required this.build, Key? key}) : super(key: key);

  @override
  State createState() => _CharacterViewer();
}

class _CharacterViewer extends State<BuildViewer> {
  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: 0);

    return Consumer<BuildManager>(builder: (context, state, child) {
      if (!widget.build.isLoaded) {
        state.load(widget.build);
      }

      List<Widget> views = [];
      views.add(PerksResume(buildRef: widget.build));
      for (int i = 0; i < 4; i++) {
        Perks? perks = widget.build.getPerks(i);
        if (perks != null) {
          views.add(PerksViewer(
              character: widget.build.character,
              perks: perks,
              tree: i,
              build: widget.build));
        }
      }

      return Scaffold(
        backgroundColor: app_colors.primaryBackgroundColor,
        appBar: AppBar(
            title: Text("Build ${widget.build.name}",
                style: Theme.of(context).textTheme.headline1)),
        body: !widget.build.isLoaded
            ? const CircularProgressIndicator()
            : GFFloatingWidget(
                child: GlobalPerks(buildRef: widget.build),
                body: PageView(controller: controller, children: views),
                verticalPosition: MediaQuery.of(context).size.height * 0.80,
                horizontalPosition: 10),
      );
    });
  }
}
