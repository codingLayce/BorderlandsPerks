import 'package:borderlands_perks/models/build.dart';
import 'package:borderlands_perks/services/build_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;

class GlobalPerks extends StatelessWidget {
  final Build buildRef;

  const GlobalPerks({required this.buildRef, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BuildManager>(builder: (context, state, child) {
      return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
              border: Border.all()),
          child: RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "${buildRef.skillPoints}",
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: buildRef.skillPoints == 0
                        ? Colors.red
                        : app_colors.textAttributColor)),
            TextSpan(
                text: " / ${buildRef.maxSkillPoints}",
                style: const TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black))
          ])));
    });
  }
}
