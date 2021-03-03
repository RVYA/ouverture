import 'package:flutter/foundation.dart' show describeEnum, required;

import 'package:equatable/equatable.dart';

import 'user.dart';


enum MemberType { household, guest, servitor }

extension DescribeMemberType on MemberType {
  String get value => describeEnum(this);
}


abstract class Member extends Equatable {
  const Member({
    @required this.type,
    @required this.details,
  });

  final MemberType type;
  final User details;

  List<Object> get descendantProps;
  String get id => details.id;
  @override
  List<Object> get props => <Object>[ type, details.id, ...descendantProps ];
}


class Household extends Member {
  const Household({
    @required User details,
    Map<MemberType, String> droppedNotes,
    @required this.isHouseholder,
  })
    : this.droppedNotes = droppedNotes ?? const <MemberType, String>{
                                            MemberType.guest: "",
                                            MemberType.household: "",
                                            MemberType.servitor: "",
                                          },
      super(
        type   : MemberType.household,
        details: details,
      );
  
  final Map<MemberType, String> droppedNotes;
  final bool isHouseholder;

  @override
  List<Object> get descendantProps => <Object>[ droppedNotes, isHouseholder, ];
}


abstract class NonHousehold<T> extends Member {
  const NonHousehold({
    @required User details,
    @required this.permissions,
    @required MemberType type,
  })
    : super(
        details: details,
        type: type,
      );

  final List<T> permissions;

  @override
  List<Object> get descendantProps => <Object>[ permissions ];


  bool doesHavePermissionFor<T>(T permission) => permissions.contains(permission);

  List<int> permissionsAsIndices();
}


enum GuestPermissions {
  canAccessHousehold,
  canAccessContactInformation,
  canReceiveNotiHI,
}
// TODO: Implement NotiHI
class Guest extends NonHousehold<GuestPermissions> {
  const Guest({
    @required User details,
    @required List<GuestPermissions> permissions,
  })
    : super(
        details: details,
        permissions: permissions,
        type: MemberType.guest,
      );

  @override
  List<int> permissionsAsIndices() {
    return
      permissions.map<int>( (GuestPermissions perm) => perm.index );
  }
}


enum ServitorPermissions {
  canInitiateContact
}

class Servitor extends NonHousehold<ServitorPermissions> {
  const Servitor({
    @required User details,
    @required List<ServitorPermissions> permissions,
  })
    : super(
        details: details,
        permissions: permissions,
        type: MemberType.servitor,
      );

  @override
  List<int> permissionsAsIndices() {
    return
      permissions.map<int>( (ServitorPermissions perm) => perm.index );
  }
}