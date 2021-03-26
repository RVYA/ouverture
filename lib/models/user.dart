import 'package:flutter/material.dart';

import 'ouverture_model.dart';
import 'place.dart';


const String  // TODO: The phone number may be stored seperately. Must decide the ID system for phone numbers.
  kUserDocKeyForename       = "forename",
  kUserDocKeySurname        = "surname",
  kUserDocKeyCurrentPlaceId = "currentPlaceId";

const String _kPathTigerPhoto = "assets/images/tiger_closeup.png";
const ImageProvider kDefaultUserPhotograph = const AssetImage(_kPathTigerPhoto);


class User extends OuvertureModel {
  const User({
    required String id,
    required this.forename,
    required this.surname,
    required this.phoneNumber,
    required this.photograph,
    required this.currentPlace,
  }) : super(id: id);

  static const User unknown =
      const User(
        id          : kUnknown,
        forename    : kUnknown,
        surname     : kUnknown,
        phoneNumber : kUnknown,
        photograph  : kDefaultUserPhotograph,
        currentPlace: Place.unknown,
      );

  final String forename, surname;
  final String phoneNumber;
  final ImageProvider photograph;
  final Place currentPlace;

  @override
  List<Object> get customProps => <Object>[
                                    this.id,
                                    this.forename,
                                    this.surname,
                                    this.phoneNumber,
                                    this.photograph,
                                    this.currentPlace,
                                  ];


  User copyWith({
    String? id,
    String? forename,
    String? surname,
    String? phoneNumber,
    ImageProvider? photograph,
    Place? place,
  }) {
    return User(
      id          : id          ?? this.id,
      forename    : forename    ?? this.forename,
      surname     : surname     ?? this.surname,
      phoneNumber : phoneNumber ?? this.phoneNumber,
      photograph  : photograph  ?? this.photograph,
      currentPlace: place       ?? this.currentPlace,
    );
  }

  @override
  Map<String, dynamic> toDocument() {
    return
      <String, dynamic>{
        kUserDocKeyForename      : forename,
        kUserDocKeySurname       : surname,
        kUserDocKeyCurrentPlaceId: currentPlace.id,
      };
  }
}