import 'package:flutter/foundation.dart' show required;

import 'package:equatable/equatable.dart';


const String kUnknown = "UNKNOWN";


abstract class OuvertureModel extends Equatable {
  const OuvertureModel({
    required this.id,
  });

  final String id;

  List<Object> get customProps;
  @override
  List<Object> get props => <Object>[ id, ...customProps ]; 


  Map<String, dynamic> toDocument();

  OuvertureModel copyWith({@required String id,});
}