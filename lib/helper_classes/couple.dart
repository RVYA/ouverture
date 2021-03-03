import 'package:flutter/foundation.dart' show required;

import 'package:equatable/equatable.dart';


class Couple<H, T> extends Equatable {
  const Couple(this.head, this.tail);

  final H head;
  final T tail;

  @override
  List<Object> get props => <Object>[ this.head, this.tail ];
}