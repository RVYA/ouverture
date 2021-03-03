import 'package:flutter/foundation.dart' show required;

import 'member.dart';
import 'ouverture_model.dart';


const String
  kPlaceDocKeyName      = "name",
  kPlaceDocKeyGuests    = "guests",
  kPlaceDocKeyHousehold = "household",
  kPlaceDocKeyServitors = "servitors";
const String     // Each *Ids has it's own array. Each element is an map.
  kPlaceDocIdMapKeyId            = "id",           // All members have id key in map.
  kPlaceDocIdMapKeyIsHouseholder = "isHouseholder",// Household members have isHouseholder key in map.
  kPlaceDocIdMapKeyPermissions   = "permissions",  // Non-household members have permissions key in map.
  kPlaceDocIdMapKeyDroppedNotes  = "droppedNotes"; // Household members have droppedNotes key in map.


class Place extends OuvertureModel {
  const Place({
    @required String id,
    @required this.name,
  })
    : this.members = const <MemberType, Set<Member>>{
                            MemberType.guest    : <Guest>{ },
                            MemberType.household: <Household>{ },
                            MemberType.servitor : <Servitor>{ },
                           },
      super(id: id,);

  const Place.withMembers({
    @required String id,
    @required this.name,
    @required this.members,
  })
    : super(id: id,);

  final String name;
  final Map<MemberType, Set<Member>> members;

  @override
  List<Object> get customProps => <Object>[ name, members ];

  Household get householder {
    return
      members[MemberType.household]
        .singleWhere(
          (Member member) => (member as Household).isHouseholder,
         );
  }


  List<Member> getMembersOfType(MemberType type) => members[type].toList(growable: false);

  bool addMember(Member newMember) => members[newMember.type].add(newMember);
  bool removeMember(Member member) => members[member.type].remove(member);

  @override
  Place copyWith({
    String id,
    String name,
    Map<MemberType, Set<Member>> members,
  }) {
    return
      Place.withMembers(
        id     : id      ?? this.id,
        name   : name    ?? this.name,
        members: members ?? this.members,
      );
  }

  @override
  Map<String, dynamic> toDocument() {
    final List<Map>
      guestIds =
        (members[MemberType.guest] as List<Guest>)
          .map<Map>(
            (Guest member)
              => <String, dynamic>{
                  kPlaceDocIdMapKeyId: member.id,
                  kPlaceDocIdMapKeyPermissions: member.permissionsAsIndices(),
                 },
           ),
      householdIds =
        (members[MemberType.household] as List<Household>)
          .map<Map>(
            (Household member)
              => <String, dynamic>{
                  kPlaceDocIdMapKeyId: member.id,
                  kPlaceDocIdMapKeyIsHouseholder: member.isHouseholder,
                  kPlaceDocIdMapKeyDroppedNotes: Map<String, String>.fromIterable(
                      member.droppedNotes.entries,
                      key: (entry) => entry.key.value,
                      value: (entry) => member.droppedNotes[entry.key],
                    ),
                 },
           ),
      servitorIds =
        (members[MemberType.servitor] as List<Servitor>)
          .map<Map>(
            (Servitor member)
              => <String, dynamic>{
                  kPlaceDocIdMapKeyId: member.id,
                  kPlaceDocIdMapKeyPermissions: member.permissionsAsIndices(),
                 },
           );

    return
      <String, dynamic>{
        kPlaceDocKeyName     : name,         // String
        kPlaceDocKeyGuests   : guestIds,     // Array of compound map
        kPlaceDocKeyHousehold: householdIds, // Array of compound map
        kPlaceDocKeyServitors: servitorIds,  // Array of compound map
      };
  }
}


/*
a() {
  final DocumentSnapshot placeDoc = await _placesRef.doc(placeId).get();

    if (!placeDoc.exists) throw PlaceIsNotRecordedException();
      
    Household householder;

    final Map<MemberType, Set<Member>> members =
        Map.fromIterable(
          MemberType.values,
          key: (type) => type,
          value: (type) {
            final List<Map> ids = placeDoc.data()["${type.value}Ids"];
            Member Function(int) memberGenerator;
            
            switch (type as MemberType) {
              case MemberType.household:
                if (!doReturnHousehold) {
                  final Map householderData =
                      ids.singleWhere(
                        (Map data) => (data[kPlaceDocIdMapKeyIsHouseholder] as bool)
                      );
                  return <Household>{
                    Household(
                      isHouseholder: true,
                      droppedNotes: householderData[kPlaceDocIdMapKeyDroppedNotes],
                      details: UserRepository().g
                    ),
                  };
                }
                memberGenerator = (int index) {
                  return
                    Household(
                      isHouseholder: ids[index][kPlaceDocIdMapKeyIsHouseholder],
                      droppedNotes: ids[index][kPlaceDocIdMapKeyDroppedNotes],
                      details: User(

                      ),
                    );
                };       
                break;
              case MemberType.guest:
                // TODO: Handle this case.
                break;
              case MemberType.servitor:
                // TODO: Handle this case.
                break;
            }

            return
              List<Member>.generate(ids.length, memberGenerator)
                          .toSet();
          }
        );

      if (householder == null) {
        throw PlaceDoesNotHaveOwnerException(
                message: "Place \"$placeId\" does not have an \"householder\".",
              );
      }

      return
        Place.withMembers(
          id         : placeDoc.id,
          name       : placeDoc.data()[kPlaceDocKeyName],
          householder: householder,
          members    : members,
        );
    }
}*/