import 'package:flutter/foundation.dart' show required;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper_classes/couple.dart';


class UserIsNotRegisteredException implements Exception {
  const UserIsNotRegisteredException({this.message});

  final String? message;

  @override
  String toString() => message ?? "$this.runtimeType";
}


class PhoneNumberRegistry extends Couple<String, String> {
  const PhoneNumberRegistry({
    required String phoneNumber,
    required String userId,
  })
    : super(
        phoneNumber,
        userId,
      );

  String get phoneNumber => this.head;
  String get userId => this.tail;
}


const String _kPhoneNumbersCollection = "phone-numbers";
const String _kPhoneNumberDocNumberFieldKey = "phoneNumber";
const String _kPhoneNumberDocIdSalt = "ph0n3nvmb3r";

class PhoneNumberRepository {
  PhoneNumberRepository._internal()
    : this._phoneNumbersRef = FirebaseFirestore.instance
                                  .collection(_kPhoneNumbersCollection);

  factory PhoneNumberRepository() => _instance;
  static final PhoneNumberRepository _instance = PhoneNumberRepository._internal();
  
  final CollectionReference _phoneNumbersRef;


  ///
  /// Throws _UserIsNotRegisteredException_ if the specified userId is not
  /// recorded in the database. This also means that the phone number is not
  /// used, yet, too.
  ///
  Future<String> getPhoneNumberOf({required String userId}) async {
    final DocumentSnapshot phoneNumberDoc =
        await _phoneNumbersRef
                .doc("$_kPhoneNumbersCollection$_kPhoneNumberDocIdSalt")
                .get();
    if (!phoneNumberDoc.exists) {
      throw UserIsNotRegisteredException();
    } else {
      return
        phoneNumberDoc.data()![_kPhoneNumberDocNumberFieldKey];
    }
  }

  ///
  /// Throws _UserIsNotRegisteredException_ if the specified _phone number_ could not
  /// be found in the _phone-numbers_ collection. If the _phone number_ is found in
  /// database, a _PhoneNumberRegistry_ is returned with phone number and id of the
  /// user that is registered with that number.
  ///
  Future<bool> doesPhoneNumberExists({
    required String phoneNumber,
    void Function(PhoneNumberRegistry phoneNumberRegistry)? ifExists,
  }) async {
    final QuerySnapshot phoneNumberQuery =
        await _phoneNumbersRef.where(
                                _kPhoneNumberDocNumberFieldKey,
                                isEqualTo: phoneNumber
                               ).get();
    if (phoneNumberQuery.size == 0) return false;

    if (ifExists != null) {
      final DocumentSnapshot phoneNumberDoc = phoneNumberQuery.docs.first;
      ifExists(
        PhoneNumberRegistry(
          phoneNumber: phoneNumberDoc.data()![_kPhoneNumberDocNumberFieldKey],
          userId: phoneNumberDoc.id.replaceFirst(_kPhoneNumberDocIdSalt, ""),
        )
      );
    }
    return true;
  }

  ///
  /// In normal circumstances, this function will not be called if the
  /// user/phone number already exists in database. Adds phone number for
  /// specified _User_ using the _id_ field. Phone number is registered
  /// by generating a document with _User id_ + _salt_.
  /// Also, because the country code will be declared using a selector,
  /// validation must also be done on the input mechanism.
  ///
  Future<void> addPhoneNumber({
    required String phoneNumber,
    required String userId,
  }) async {
    return
      await _phoneNumbersRef.doc("$userId$_kPhoneNumberDocIdSalt")
                            .set(
                              <String, dynamic>{
                                _kPhoneNumberDocNumberFieldKey: phoneNumber,
                              }
                             );
  }

  ///
  /// The control of whether the phone number is registered must be done in
  /// _UserRepository_. If the user is registered, then the associated phone number
  /// document must be deleted.
  ///
  Future<void> deletePhoneNumber({required String userId}) {
    return
      _phoneNumbersRef.doc("$userId$_kPhoneNumberDocIdSalt")
                      .delete();
  }
}