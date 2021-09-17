import 'package:borderlands_perks/models/character.dart';
import 'package:borderlands_perks/models/perks.dart';
import 'package:borderlands_perks/screens/components/global_perks.dart';
import 'package:borderlands_perks/screens/pages/perks_resume.dart';
import 'package:borderlands_perks/screens/pages/perks_viewer.dart';
import 'package:borderlands_perks/services/perks_manager.dart';
import 'package:flutter/material.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class CharacterViewer extends StatefulWidget {
  final Character character;

  const CharacterViewer({required this.character, Key? key}) : super(key: key);

  @override
  State createState() => _CharacterViewer();
}

class _CharacterViewer extends State<CharacterViewer> {
  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: 0);

    return ChangeNotifierProvider(
        create: (context) => PerksManager(),
        child: Consumer<PerksManager>(builder: (context, state, child) {
          if (!state.perksRetrieved && !state.loading) {
            state.load(widget.character.getPaths());
          }

          List<Widget> views = [];
          views.add(const PerksResume(character: Character.fl4k));
          for (int i = 0; i < 4; i++) {
            Perks? perks = state.getPerks(i);
            if (perks != null) {
              views.add(PerksViewer(
                  character: Character.fl4k, perks: perks, tree: i));
            }
          }

          return Scaffold(
            backgroundColor: app_colors.primaryBackgroundColor,
            appBar: AppBar(title: const Text("Borderlands Perks")),
            body: state.loading
                ? const CircularProgressIndicator()
                : GFFloatingWidget(
                    child: const GlobalPerks(),
                    body: PageView(controller: controller, children: views),
                    verticalPosition: MediaQuery.of(context).size.height * 0.80,
                    horizontalPosition: 10),
          );
        }));
  }
}
