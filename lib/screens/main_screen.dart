import 'package:borderlands_perks/models/character.dart';
import 'package:borderlands_perks/screens/components/global_perks.dart';
import 'package:borderlands_perks/screens/components/perks_viewer.dart';
import 'package:borderlands_perks/services/perks_manager.dart';
import 'package:flutter/material.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: 0);

    return ChangeNotifierProvider(
        create: (context) => PerksManager(),
        child: Consumer<PerksManager>(builder: (context, state, child) {
          return Scaffold(
            backgroundColor: app_colors.primaryBackgroundColor,
            appBar: AppBar(title: const Text("Borderlands Perks")),
            body: GFFloatingWidget(
                child: const GlobalPerks(),
                body: PageView(controller: controller, children: const [
                  PerksViewer(character: Character.fl4k, tree: 1),
                  PerksViewer(character: Character.fl4k, tree: 2),
                  PerksViewer(character: Character.fl4k, tree: 3),
                  PerksViewer(character: Character.fl4k, tree: 4),
                ]),
                verticalPosition: MediaQuery.of(context).size.height * 0.85,
                horizontalPosition: 10),
          );
        }));
  }
}
