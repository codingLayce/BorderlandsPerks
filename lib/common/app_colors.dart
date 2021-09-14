import 'package:flutter/material.dart';

const firstTreeColor = Color.fromRGBO(51, 83, 123, 1.0);
const secondTreeColor = Color.fromRGBO(35, 90, 24, 1.0);
const thirdTreeColor = Color.fromRGBO(121, 81, 49, 1.0);
const fourthTreeColor = Color.fromRGBO(76, 18, 97, 1.0);

const textColor = Color.fromRGBO(0, 0, 0, 0.6);

const primaryBackgroundColor = Color.fromRGBO(243, 242, 239, 1.0);
const Map<int, Color> _clouds = {
  50: Color.fromRGBO(236, 240, 241, .1),
  100: Color.fromRGBO(236, 240, 241, .2),
  200: Color.fromRGBO(236, 240, 241, .3),
  300: Color.fromRGBO(236, 240, 241, .4),
  400: Color.fromRGBO(236, 240, 241, .5),
  500: Color.fromRGBO(236, 240, 241, .6),
  600: Color.fromRGBO(236, 240, 241, .7),
  700: Color.fromRGBO(236, 240, 241, .8),
  800: Color.fromRGBO(236, 240, 241, .9),
  900: Color.fromRGBO(236, 240, 241, 1.0)
};
const MaterialColor cloudsMColor = MaterialColor(0xFFECF0F1, _clouds);
