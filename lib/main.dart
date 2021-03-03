import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:country_codes/country_codes.dart';

import 'values/routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[
      DeviceOrientation.portraitDown, DeviceOrientation.portraitUp,
    ],
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  await CountryCodes.initialize();

  Paint.enableDithering = true;

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        splashFactory: InkRipple.splashFactory,
      ),
      initialRoute: kWelcomeRoute,
      routes: kRoutesMap,
    );
  }
}