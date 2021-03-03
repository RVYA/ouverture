import 'package:flutter/foundation.dart' show required;

import 'package:equatable/equatable.dart';


abstract class OuvertureModel extends Equatable {
  const OuvertureModel({
    @required this.id,
  })
    : assert(id != null, "ID can not be NULL.");

  final String id;

  List<Object> get customProps;
  @override
  List<Object> get props => <Object>[ id, ...customProps ]; 


  Map<String, dynamic> toDocument();

  OuvertureModel copyWith({@required String id,});
}