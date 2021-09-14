import 'package:borderlands_perks/services/perks_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlobalPerks extends StatelessWidget {
  const GlobalPerks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PerksManager>(builder: (context, state, child) {
      return Text("${state.skillsPoint}");
    });
  }
}
