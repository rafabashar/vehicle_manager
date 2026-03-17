import 'package:equatable/equatable.dart';

abstract class PersistenceState extends Equatable {
  const PersistenceState();
  @override
  List<Object?> get props => [];
}

class PersistenceIdle extends PersistenceState {}

class PersistenceSaving extends PersistenceState {}

class PersistenceLoaded extends PersistenceState {}

class PersistenceError extends PersistenceState {
  final String message;
  const PersistenceError(this.message);
  @override
  List<Object?> get props => [message];
}