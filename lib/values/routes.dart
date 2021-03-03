import 'package:flutter/material.dart';
import 'package:ouverture/screens/place_details/place_details.dart';

import '../screens/place_book/place_book.dart';
import '../screens/welcome/welcome.dart';

// TODO: Complete Routes map.
const String
  kWelcomeRoute      = "/",
  kPlaceBookRoute    = "/place-book",
  kPlaceDetailsRoute = "/place-book/place-details";

final Map<String, Widget Function(BuildContext)> kRoutesMap =
    <String, WidgetBuilder>{
      kWelcomeRoute     : (BuildContext context) => Welcome(),
      kPlaceBookRoute   : (BuildContext context) => PlaceBook(),
      kPlaceDetailsRoute: (BuildContext context) => PlaceDetails(),
    };