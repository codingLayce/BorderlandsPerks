import 'package:borderlands_perks/screens/builds_viewer.dart';
import 'package:borderlands_perks/services/build_manager.dart';
import 'package:borderlands_perks/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;
import 'package:provider/provider.dart';

void main() async {
  await Storage().init();
  runApp(const MyApp());
}

const font = "Roboto";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BuildManager>(
        create: (context) => BuildManager(),
        child: MaterialApp(
            title: 'Borderlands Perks',
            theme: ThemeData(
                primarySwatch: app_colors.cloudsMColor,
                textTheme: const TextTheme(
                    headline1: TextStyle(
                        fontFamily: font,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: app_colors.textColor),
                    bodyText1: TextStyle(
                        fontFamily: font,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: app_colors.textColor),
                    caption: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontFamily: font,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: app_colors.textColor))),
            home: const BuildsViewer()));
  }
}
