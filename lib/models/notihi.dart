import 'package:flutter/foundation.dart' show required;

import 'ouverture_model.dart';


const String kNotiHiSoundFile = ""; // TODO: Add Sound File.

const String _kNotiHiDefaultMessage = "Hey! (^o^)/";


class NotiHi extends OuvertureModel {
  const NotiHi({
    required String id,
    this.message = _kNotiHiDefaultMessage,
    required this.recipientId,
    required this.senderId,
  })
    : super(id: id,);

  final Duration expirationDuration = const Duration(minutes: 1); // TODO: Maybe not required
  final String message;
  final String recipientId, senderId;
  final String soundFile = kNotiHiSoundFile; // TODO: Maybe add a feature for changing the sound.

  @override
  List<Object> get customProps => <Object>[ message, recipientId, senderId ];


  @override
  NotiHi copyWith({
    String? id,
    String? message,
    String? recipientId,
    String? senderId,
    //String soundFile, TODO: Useless.
  }) {
    return
      NotiHi(
        id         : id ?? this.id,
        message    : message ?? this.message,
        recipientId: recipientId ?? this.recipientId,
        senderId   : senderId ?? this.senderId,
      );
  }

  @override
  Map<String, dynamic> toDocument() {
    throw Exception("A NotiHI should not be recorded in database.");
  }
}