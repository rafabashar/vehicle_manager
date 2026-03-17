import 'package:equatable/equatable.dart';

abstract class PersistenceEvent extends Equatable {
  const PersistenceEvent();
  @override
  List<Object?> get props => [];
}

class PersistLoadEvent extends PersistenceEvent {}

class PersistSaveEvent extends PersistenceEvent {}