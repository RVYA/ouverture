import 'dart:io' as io;

import 'package:flutter/painting.dart' show NetworkImage;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;


const String _kUserPhotosFolder = "user-photographs";
const String _kUserPhotoSalt = "ph0t0gr4ph";

const String _kPreferredImageFormat = "png";
const int _kPreferredImageWidth = 400;

// TODO: !!! Add "lastModified" date metadata to repositories.
class PhotographRepository {
  PhotographRepository._internal()
    : this._userPhotosRef = FirebaseStorage.instance.ref(_kUserPhotosFolder);

  factory PhotographRepository() => _instance;
  static final PhotographRepository _instance = PhotographRepository._internal();

  final Reference _userPhotosRef;


  String _generateImageName({required String userId,}) {
    return "$_kUserPhotoSalt$userId.$_kPreferredImageFormat";
  }

  io.File _convertImageToPng({required io.File image}) {
    if (image.path.split(".").last == _kPreferredImageFormat) {
      return image;
    } else {
      final img.Image
        decodedImage = img.decodeImage(image.readAsBytesSync())!,
        resizedImage = img.copyResize(decodedImage, width: _kPreferredImageWidth);

      return
        io.File("temp_profile_img.png")
          ..writeAsBytesSync(img.encodePng(resizedImage));
    }
  }

  Future<NetworkImage> downloadPhotograph({required String userId,}) async {
    final String downloadUrl = await _userPhotosRef
        .child(_generateImageName(userId: userId))
        .getDownloadURL();

    return NetworkImage(downloadUrl);
  }

  Future<void> deletePhotograph({required String userId,}) {
    return
      _userPhotosRef
        .child(_generateImageName(userId: userId))
        .delete();
  }

  Future<void> updatePhotograph({
    required String userId,
    required io.File image,
  }) async {
    // I am not sure about this one... It looks pretty trivial 0.o
    await deletePhotograph(userId: userId);
    await uploadPhotograph(userId: userId, image: image);
  }

  Future<void> uploadPhotograph({
    required String userId,
    required io.File image,
  }) async {
    image = _convertImageToPng(image: image);

    await
      _userPhotosRef
        .child(_generateImageName(userId: userId,),)
        .putFile(image);
  }
}