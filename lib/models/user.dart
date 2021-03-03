import 'package:flutter/material.dart';

import 'ouverture_model.dart';
import 'place.dart';


const String kUnknown = "UNKNOWN";

const String  // TODO: The phone number may be stored seperately. Must decide the ID system for phone numbers.
  kUserDocKeyForename       = "forename",
  kUserDocKeySurname        = "surname",
  kUserDocKeyPhotoUrl       = "photographUrl",
  kUserDocKeyCurrentPlaceId = "currentPlaceId";


class User extends OuvertureModel {
  const User({
    @required String id,
    @required this.forename,
    @required this.surname,
    @required this.phoneNumber,
    @required this.photographUrl,
    @required this.currentPlace,
  }) : super(id: id);

  static const User unknown =
      const User(
        id           : kUnknown,
        forename     : kUnknown,
        surname      : kUnknown,
        phoneNumber  : kUnknown,
        photographUrl: kUnknown,
        currentPlace : null,
      );

  final String forename, surname;
  final String phoneNumber;
  final String photographUrl;
  final Place currentPlace;

  @override
  List<Object> get customProps => <Object>[
                                    this.id,
                                    this.forename,
                                    this.surname,
                                    this.phoneNumber,
                                    this.photographUrl,
                                    this.currentPlace,
                                  ];


  User copyWith({
    String id,
    String forename,
    String surname,
    String phoneNumbers,
    String photographUrl,
    Place place,
  }) {
    return User(
      id            : id            ?? this.id,
      forename      : forename      ?? this.forename,
      surname       : surname       ?? this.surname,
      phoneNumber   : phoneNumbers  ?? this.phoneNumber,
      photographUrl : photographUrl ?? this.photographUrl,
      currentPlace  : place         ?? this.currentPlace,
    );
  }

  @override
  Map<String, dynamic> toDocument() {
    return
      <String, dynamic>{
        kUserDocKeyForename      : forename,
        kUserDocKeySurname       : surname,
        kUserDocKeyPhotoUrl      : photographUrl,
        kUserDocKeyCurrentPlaceId: currentPlace.id,
      };
  }
}