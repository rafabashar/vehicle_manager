import 'package:equatable/equatable.dart';
import '../../enums/vehicle_type.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();
  @override
  List<Object?> get props => [];
}

class LoadVehiclesEvent extends VehicleEvent {}

class SaveVehiclesEvent extends VehicleEvent {}

class DeleteVehicleEvent extends VehicleEvent {
  final String id; // plateNum.toString()
  final VehicleType type;
  const DeleteVehicleEvent(this.id, this.type);

  @override
  List<Object?> get props => [id, type];
}

class AddVehicleEvent extends VehicleEvent {
  final dynamic vehicle; // Car/Truck/Motorcycle
  final VehicleType type;
  const AddVehicleEvent(this.vehicle, this.type);

  @override
  List<Object?> get props => [vehicle, type];
}

class InsertVehicleAtEvent extends VehicleEvent {
  final int index;
  final dynamic vehicle;
  final VehicleType type;
  const InsertVehicleAtEvent(this.index, this.vehicle, this.type);

  @override
  List<Object?> get props => [index, vehicle, type];
}

class UpdateVehicleEvent extends VehicleEvent {
  final dynamic updated;
  final VehicleType type;
  const UpdateVehicleEvent(this.updated, this.type);

  @override
  List<Object?> get props => [updated, type];
}