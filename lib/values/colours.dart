import 'package:flutter/material.dart' show Alignment, Color, LinearGradient;


const Color
  kPrimary          = _kBlack;                  // Black
const LinearGradient
  kSecondary        = _kVelvetGradient; // TODO: Decide on a secondary color.
const Color
  kBackground       = _kWhite,                  // Light Grey
  kSurface          = _kWhite,                  // Light Grey
  kError            = const Color(0xFFFB766E),  // Bright Red
  kSuccess          = const Color(0xFF9FF872),  // Bright Green
  kWarning          = const Color(0xFFFFC85F),  // Bright Yellow
  kOnPrimary        = _kWhite,                  // Light Grey
  kOnBackground     = _kBlack,                  // Black
  kOnSurface        = _kBlack,                  // Black
  kOnError          = _kWhite                   // Light Grey
  ;


const Color
  _kWhite = const Color(0xFFFCF7F4),            // Light Grey
  _kBlack = const Color(0xFF000000);            // Black

const LinearGradient
  kBlackFade      = const LinearGradient(
                      begin: Alignment.centerLeft, end: Alignment.centerRight,
                      colors: <Color>[
                        _kBlack,                  //  Black
                        const Color(0x00000000),  //  Black-Transparent
                      ],
                    ),
  kWhiteFade      = const LinearGradient(
                      begin: Alignment.centerLeft, end: Alignment.centerRight,
                      colors: <Color>[
                        _kWhite,                  //  White
                        const Color(0x00FFFFFF),  //  White-Transparent
                      ],
                    ),
  kDarkGradient   = const LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: <Color>[
                        const Color(0xFF000000),  //  Black
                        const Color(0xFF121212),  //  Dark Grey
                      ],
                    ),
  kLightGradient  = const LinearGradient(
                      begin: Alignment.bottomLeft, end: Alignment.topRight,
                      colors: const <Color>[
                        const Color(0xFFFFFFFF),  // White
                        _kWhite,                  // Light Grey
                      ],
                    ),
  _kVelvetGradient = const LinearGradient(
                      begin: Alignment.centerLeft, end: Alignment.centerRight,
                      colors: <Color>[
                        const Color(0xFF6D0000),  //  Darkest Red
                        const Color(0xFF870000),  //  Dark Red
                        const Color(0xFF9A0202),  //  Red
                        const Color(0xFFAE0000),  //  Light Red
                        const Color(0xFFD00404),  //  Lightest Red
                      ],
                    );