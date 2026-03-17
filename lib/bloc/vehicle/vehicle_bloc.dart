import 'package:flutter_bloc/flutter_bloc.dart';

import '../../enums/vehicle_type.dart';
import '../../repository/vehicle_repository.dart';

import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository repo;

  VehicleBloc(this.repo) : super(VehicleInitial()) {
    on<LoadVehiclesEvent>(_onLoad);
    on<SaveVehiclesEvent>(_onSave);
    on<AddVehicleEvent>(_onAdd);
    on<InsertVehicleAtEvent>(_onInsert);
    on<UpdateVehicleEvent>(_onUpdate);
    on<DeleteVehicleEvent>(_onDelete);
  }

  Future<void> _onLoad(LoadVehiclesEvent event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    try {
      await repo.load();
      emit(VehicleLoaded(cars: repo.cars, motorcycles: repo.motorcycles, trucks: repo.trucks));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onSave(SaveVehiclesEvent event, Emitter<VehicleState> emit) async {
    try {
      await repo.save();
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onAdd(AddVehicleEvent event, Emitter<VehicleState> emit) async {
    if (state is! VehicleLoaded) return;

    try {
      if (event.type == VehicleType.car) repo.addCar(event.vehicle);
      if (event.type == VehicleType.motorcycle) repo.addMotorcycle(event.vehicle);
      if (event.type == VehicleType.truck) repo.addTruck(event.vehicle);

      emit(VehicleLoaded(cars: repo.cars, motorcycles: repo.motorcycles, trucks: repo.trucks));
      await repo.save();
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onInsert(InsertVehicleAtEvent event, Emitter<VehicleState> emit) async {
    if (state is! VehicleLoaded) return;

    try {
      if (event.type == VehicleType.car) {
        repo.insertCar(event.index.clamp(0, repo.cars.length), event.vehicle);
      }
      if (event.type == VehicleType.motorcycle) {
        repo.insertMotorcycle(event.index.clamp(0, repo.motorcycles.length), event.vehicle);
      }
      if (event.type == VehicleType.truck) {
        repo.insertTruck(event.index.clamp(0, repo.trucks.length), event.vehicle);
      }

      emit(VehicleLoaded(cars: repo.cars, motorcycles: repo.motorcycles, trucks: repo.trucks));
      await repo.save();
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateVehicleEvent event, Emitter<VehicleState> emit) async {
    if (state is! VehicleLoaded) return;

    try {
      if (event.type == VehicleType.car) repo.updateCar(event.updated);
      if (event.type == VehicleType.motorcycle) repo.updateMotorcycle(event.updated);
      if (event.type == VehicleType.truck) repo.updateTruck(event.updated);

      emit(VehicleLoaded(cars: repo.cars, motorcycles: repo.motorcycles, trucks: repo.trucks));
      await repo.save();
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteVehicleEvent event, Emitter<VehicleState> emit) async {
    if (state is! VehicleLoaded) return;

    try {
      repo.deleteById(event.id, event.type);
      emit(VehicleLoaded(cars: repo.cars, motorcycles: repo.motorcycles, trucks: repo.trucks));
      await repo.save();
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }
}