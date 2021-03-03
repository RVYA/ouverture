import 'package:flutter/foundation.dart' show required;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/member.dart';
import '../models/place.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';


class PlaceIsNotRecordedException implements Exception {
  const PlaceIsNotRecordedException({this.message});

  final String message;

  @override
  String toString() => message ?? this.runtimeType;
}

class PlaceDoesNotHaveOwnerException implements Exception {
  const PlaceDoesNotHaveOwnerException({this.message});

  final String message;

  @override
  String toString() => message ?? this.runtimeType;
}


const String _kPlacesCollection = "places";


class PlaceRepository {
  PlaceRepository._internal()
    : this._placesRef = FirebaseFirestore.instance
                                         .collection(_kPlacesCollection);

  factory PlaceRepository() => _instance;
  static final PlaceRepository _instance = PlaceRepository._internal();
  
  final CollectionReference _placesRef;


  ///
  ///
  ///
  Future<Place> getPlaceWith({
    @required String placeId,
    bool doReturnGuests = false,
    bool doReturnHousehold = false,
    bool doReturnServitors = false,
  }) async {
    final DocumentSnapshot placeDoc = await _placesRef.doc(placeId).get();

    if (!placeDoc.exists) throw PlaceIsNotRecordedException();

    final Set<Guest> guests = (doReturnGuests)?
        await _getGuests(guestsData: placeDoc.get(kPlaceDocKeyGuests) as List<Map>,)
          : <Guest>{ /* EMPTY */ };
    final Set<Household> household =
        await _getHousehold(
          householdData: placeDoc.get(kPlaceDocKeyHousehold) as List<Map>,
          doReturnOnlyHouseholder: doReturnHousehold,
        );
    final Set<Servitor> servitors = (doReturnServitors)?
        await _getServitors(servitorsData: placeDoc.get(kPlaceDocKeyServitors) as List<Map>,)
          : <Servitor>{ /* EMPTY */ };

    return
      Place.withMembers(
        id: placeDoc.id,
        name: placeDoc.get(kPlaceDocKeyName),
        members: <MemberType, Set<Member>>{
          MemberType.guest: guests,
          MemberType.household: household,
          MemberType.servitor: servitors,
        },
      );
  }

  Future<Set<Household>> _getHousehold({
    @required List<Map<String, dynamic>> householdData,
    bool doReturnOnlyHouseholder = false
  }) async {
    Set<Household> household = <Household>{ /*EMPTY*/ };

    if (doReturnOnlyHouseholder) {
      final Map<String, dynamic> householder =
        householdData.singleWhere(
            (Map data) => data[kPlaceDocIdMapKeyIsHouseholder] as bool
          );
      final Map<MemberType, String> droppedNotes =
        <MemberType, String>{
          MemberType.guest: householder[kPlaceDocIdMapKeyDroppedNotes][MemberType.guest.value],
          MemberType.household: householder[kPlaceDocIdMapKeyDroppedNotes][MemberType.household.value],
          MemberType.servitor: householder[kPlaceDocIdMapKeyDroppedNotes][MemberType.servitor.value],
        };
      
      household.add(
        Household(
          isHouseholder: true,
          details: await UserRepository().getUserWith(
              doReturnCurrentPlace: true,
              doReturnPhotographUrl: true,
              id: householder[kPlaceDocIdMapKeyId] as String,
            ),
          droppedNotes: droppedNotes,
        ),
      );
    } else {
      for (Map<String, dynamic> data in householdData) {
        final User details = await UserRepository().getUserWith(
                              doReturnCurrentPlace: true,
                              doReturnPhoneNumber: true,
                              doReturnPhotographUrl: true,
                              id: data[kPlaceDocIdMapKeyId],
                             );
        final Map<MemberType, String> droppedNotes =
          <MemberType, String>{
            MemberType.guest: data[kPlaceDocIdMapKeyDroppedNotes][MemberType.guest.value],
            MemberType.household: data[kPlaceDocIdMapKeyDroppedNotes][MemberType.household.value],
            MemberType.servitor: data[kPlaceDocIdMapKeyDroppedNotes][MemberType.servitor.value],
          };
        
        household.add(
          Household(
            isHouseholder: data[kPlaceDocIdMapKeyIsHouseholder],
            details: details,
            droppedNotes: droppedNotes,
          ),
        );
      }
    }

    return household;
  }

  Future<Set<Guest>> _getGuests({
    @required List<Map<String, dynamic>> guestsData,
  }) async {
    final Set<Guest> guests = <Guest>{ /*EMPTY*/ };

    for (Map<String, dynamic> data in guestsData) {
      final User details = await UserRepository().getUserWith(
                            id: data[kPlaceDocIdMapKeyId],
                            doReturnCurrentPlace: true,
                            doReturnPhoneNumber: true,
                            doReturnPhotographUrl: true,
                           );
      final List<GuestPermissions> permissions =
          (data[kPlaceDocIdMapKeyPermissions] as List<int>)
            .map<GuestPermissions>(
              (int permIndex) => GuestPermissions.values[permIndex],
            );

      guests.add(
        Guest(
          details: details,
          permissions: permissions,
        ),
      );
    }
    return guests;
  }

  Future<Set<Servitor>> _getServitors({
    @required List<Map<String, dynamic>> servitorsData,
  }) async {
    final Set<Servitor> servitors = <Servitor>{ /*EMPTY*/ };

    for (Map<String, dynamic> data in servitorsData) {
      final User details = await UserRepository().getUserWith(
                            id: data[kPlaceDocIdMapKeyId],
                            doReturnCurrentPlace: true,
                            doReturnPhoneNumber: true,
                            doReturnPhotographUrl: true,
                           );
      final List<ServitorPermissions> permissions =
          (data[kPlaceDocIdMapKeyPermissions] as List<int>)
            .map<ServitorPermissions>(
              (int permIndex) => ServitorPermissions.values[permIndex],
            );

      servitors.add(
        Servitor(
          details: details,
          permissions: permissions,
        ),
      );
    }
    return servitors;
  }

  ///
  ///
  ///
  Future<List<Place>> getPlacesOf({@required String userId}) { }

  ///
  ///
  ///
  Future<void> doesPlaceExists() {} // TODO: This one requires some tinkering.

  ///
  ///
  ///
  Future<Place> addPlace(Place place) {} // TODO: Decide the algorithm.

  ///
  ///
  ///
  Future<void> deletePlace(String placeId) {} // TODO: Seems straight-forward. Implement.
}