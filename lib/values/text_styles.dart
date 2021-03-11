import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'colours.dart';


TextStyle kGetDisplayStyleFor({
  Brightness brightness = Brightness.light,
}) {
  return
    TextStyle(
      color: (brightness == Brightness.light)? kOnBackground : kBackground,
      fontFamily: "Red Hat Display",
      fontSize: 25,
      fontWeight: FontWeight.w700,
      //shadows: <Shadow>[]
    );
}

TextStyle kGetMenuTitleStyleFor({
  Brightness brightness = Brightness.light,
}) {
  return
    TextStyle(
      color: (brightness == Brightness.light)? kOnBackground : kBackground,
      fontFamily: "Red Hat Display",
      fontSize: 15,
      fontWeight: FontWeight.w500,
      //shadows: <Shadow>[]
    );
}

TextStyle kGetBodyStyleFor({
  Brightness brightness = Brightness.light,
}) {
  return
    TextStyle(
      color: (brightness == Brightness.light)? kOnBackground : kBackground,
      fontFamily: "Raleway",
      fontSize: 20,
      fontWeight: FontWeight.w300,
      //shadows: <Shadow>[]
    );
}

TextStyle kGetDetailStyleFor({
  Brightness brightness = Brightness.light,
}) {
  return
    TextStyle(
      color: (brightness == Brightness.light)? kOnBackground : kBackground,
      fontFamily: "Raleway",
      fontSize: 17,
      fontWeight: FontWeight.w200,
      //shadows: <Shadow>[]
    );
}

TextStyle kGetButtonStyleFor({
  Brightness brightness = Brightness.light,
}) {
  return
    TextStyle(
      color: (brightness == Brightness.light)? kOnBackground : kBackground,
      fontFamily: "Raleway",
      fontSize: 15,
      fontWeight: FontWeight.w400,
      //shadow: <Shadow>[],
    );
}