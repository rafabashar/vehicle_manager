/*import 'package:equatable/equatable.dart';
import '../../models/car.dart';
import '../../models/motorcycle.dart';
import '../../models/truck.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();
  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<Car> cars;
  final List<Motorcycle> motorcycles;
  final List<Truck> trucks;

  const VehicleLoaded({
    required this.cars,
    required this.motorcycles,
    required this.trucks,
  });

  @override
  List<Object?> get props => [cars, motorcycles, trucks];
}

class VehicleError extends VehicleState {
  final String message;
  const VehicleError(this.message);

  @override
  List<Object?> get props => [message];
}*/

import 'package:equatable/equatable.dart';
import '../../models/car.dart';
import '../../models/motorcycle.dart';
import '../../models/truck.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

// =========================
// BASIC STATES
// =========================

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<Car> cars;
  final List<Motorcycle> motorcycles;
  final List<Truck> trucks;

  const VehicleLoaded({
    required this.cars,
    required this.motorcycles,
    required this.trucks,
  });

  @override
  List<Object?> get props => [cars, motorcycles, trucks];
}

// =========================
// ERROR STATES (NEW)
// =========================

class NetworkUnavailableState extends VehicleState {}

class ServerErrorState extends VehicleState {
  final String message;

  const ServerErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class TimeoutState extends VehicleState {
  final String message;

  const TimeoutState(this.message);

  @override
  List<Object?> get props => [message];
}

// optional fallback
class VehicleError extends VehicleState {
  final String message;

  const VehicleError(this.message);

  @override
  List<Object?> get props => [message];
}