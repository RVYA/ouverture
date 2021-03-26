import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ouverture/repositories/photograph_repository.dart';

import '../models/ouverture_model.dart' show kUnknown;
import '../models/user.dart';
import 'phone_number_repository.dart';
import 'place_repository.dart';


const String _kUsersCollection = "users";

///
/// Controls Users Collection. A user's _phone number_ and _current place_ is
/// hidden from other users that are not from the same household. These
/// informations are also handled seperately by their own _repositories_.
///
class UserRepository {
  UserRepository._internal()
    : this._usersRef = FirebaseFirestore.instance.collection(_kUsersCollection),
      this._signedUser = User.unknown;

  factory UserRepository() => _instance;
  static final UserRepository _instance = UserRepository._internal();

  final CollectionReference _usersRef;

  User _signedUser;
  User get signedUser => _signedUser;
  set signedUser(User value) {
    if (_signedUser == User.unknown || value == User.unknown) _signedUser = value;
  }


  ///
  /// If _phoneNumber_ is specified, then will return a complete User instance,
  /// with all the information stored regarding the user. If _ID_ is specified,
  /// phone number, current place and photograph url will be send based on similiar
  /// named flags. If the user itself or/and user's phone number does not exists
  /// in database, an _UserIsNotRegisteredException_ will be raised.
  ///
  Future<User> getUserWith({
    String? id,
    String? phoneNumber,
    bool doReturnPhoneNumber = false,
    /*bool doReturnCurrentPlace = false,
    bool doReturnPhotographUrl = true,*/
  }) async {
    assert(
      (id != null) || (phoneNumber != null),
      "Either \"id\" or \"phoneNumber\" must be specified.",
    );

    if (phoneNumber != null) {
      doReturnPhoneNumber = true;

      final bool doesPhoneNumberExists =
        await PhoneNumberRepository().doesPhoneNumberExists(
          phoneNumber: phoneNumber,
          ifExists: (PhoneNumberRegistry registry) {
            id = registry.userId;
          }
        );

      if (!doesPhoneNumberExists) {
        throw UserIsNotRegisteredException(
            message: "Specified phone number is not belong to any user.",
          );
      }
    }

    final DocumentSnapshot userDoc = await _usersRef.doc(id).get();

    if (!userDoc.exists) {
      throw UserIsNotRegisteredException(
              message: "User with specified \"id\" could not be found",
            );
    } else {
      if (doReturnPhoneNumber) {
        phoneNumber ??= await PhoneNumberRepository()
                                .getPhoneNumberOf(userId: userDoc.id);
      } else {
        phoneNumber = kUnknown;
      }

      return
        User(
          id          : userDoc.id,
          forename    : userDoc.get(kUserDocKeyForename),
          surname     : userDoc.get(kUserDocKeySurname),
          phoneNumber : phoneNumber,
          photograph  : await PhotographRepository().downloadPhotograph(
                userId: userDoc.id,
              ),
          currentPlace: await PlaceRepository().getPlaceWith(
                placeId: userDoc.get(kUserDocKeyCurrentPlaceId)
              ),
        );
    }
  }

  ///
  /// Will record an User instance in the database and assign an ID to User. Because,
  /// this method is intended to use at the sign-in/up screen, and initially
  /// the User instance will not have an ID associated with it. After recording
  /// User to a document, a new User instance will be returned with the initial
  /// information and the assigned document ID. Be sure to change instance of
  /// stored User.
  ///
  Future<User> addUser(User user) async {
    assert(user.currentPlace.id != kUnknown);

    final DocumentReference recUser =
        await _usersRef.add(user.toDocument());

    return user.copyWith(id: recUser.id);
  }

  ///
  /// Simply deletes the document associated with User's ID. No controls are
  /// made to check if the User exists in the database beforehand.
  ///
  Future<void> deleteUser(String userId) async => _usersRef.doc(userId).delete();

  ///
  /// This feature is not implemented yet. TODO: Think about this updateUser method.
  ///
  Future<void> updateUser(User user) async {
    throw UnimplementedError("This feature is not implemented yet.");
  }
}