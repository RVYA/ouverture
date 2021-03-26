import 'package:equatable/equatable.dart';


class Couple<H extends Object, T extends Object> extends Equatable {
  const Couple(this.head, this.tail);

  final H head;
  final T tail;

  @override
  List<Object> get props => <Object>[ this.head, this.tail ];
}