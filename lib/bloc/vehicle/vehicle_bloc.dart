/*import 'package:flutter_bloc/flutter_bloc.dart';

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
}*/


import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../enums/vehicle_type.dart';
import '../../repository/vehicle_repository.dart';

import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository repo;

  Timer? _pollingTimer;

  VehicleBloc(this.repo) : super(VehicleInitial()) {
    on<LoadVehiclesEvent>(_onLoad);
    on<SaveVehiclesEvent>(_onSave);
    on<AddVehicleEvent>(_onAdd);
    on<InsertVehicleAtEvent>(_onInsert);
    on<UpdateVehicleEvent>(_onUpdate);
    on<DeleteVehicleEvent>(_onDelete);

    // start polling automatically
    _startPolling();
  }

  // =========================
  // POLLING (EVERY 30s)
  // =========================
  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => add(LoadVehiclesEvent()),
    );
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }

  // =========================
  // LOAD
  // =========================
  Future<void> _onLoad(
      LoadVehiclesEvent event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());

    try {
      await repo.load();

      emit(VehicleLoaded(
        cars: repo.cars,
        motorcycles: repo.motorcycles,
        trucks: repo.trucks,
      ));
    } on DioException catch (e) {
      _handleDioError(e, emit);
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  // =========================
  // SAVE (optional)
  // =========================
  Future<void> _onSave(
      SaveVehiclesEvent event, Emitter<VehicleState> emit) async {
    try {
      await repo.saveCacheOnly();
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  // =========================
  // ADD
  // =========================
  Future<void> _onAdd(
      AddVehicleEvent event, Emitter<VehicleState> emit) async {
    if (state is! VehicleLoaded) return;

    try {
      if (event.type == VehicleType.car) {
        await repo.addCar(event.vehicle);
      } else if (event.type == VehicleType.motorcycle) {
        await repo.addMotorcycle(event.vehicle);
      } else if (event.type == VehicleType.truck) {
        await repo.addTruck(event.vehicle);
      }

      emit(VehicleLoaded(
        cars: repo.cars,
        motorcycles: repo.motorcycles,
        trucks: repo.trucks,
      ));
    } on DioException catch (e) {
      _handleDioError(e, emit);
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  // =========================
  // INSERT
  // =========================
  Future<void> _onInsert(
      InsertVehicleAtEvent event, Emitter<VehicleState> emit) async {
    if (state is! VehicleLoaded) return;

    try {
      if (event.type == VehicleType.car) {
        await repo.insertCar(event.index, event.vehicle);
      } else if (event.type == VehicleType.motorcycle) {
        await repo.insertMotorcycle(event.index, event.vehicle);
      } else if (event.type == VehicleType.truck) {
        await repo.insertTruck(event.index, event.vehicle);
      }

      emit(VehicleLoaded(
        cars: repo.cars,
        motorcycles: repo.motorcycles,
        trucks: repo.trucks,
      ));
    } on DioException catch (e) {
      _handleDioError(e, emit);
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  // =========================
  // UPDATE
  // =========================
  Future<void> _onUpdate(
      UpdateVehicleEvent event, Emitter<VehicleState> emit) async {
    if (state is! VehicleLoaded) return;

    try {
      if (event.type == VehicleType.car) {
        await repo.updateCar(event.updated);
      } else if (event.type == VehicleType.motorcycle) {
        await repo.updateMotorcycle(event.updated);
      } else if (event.type == VehicleType.truck) {
        await repo.updateTruck(event.updated);
      }

      emit(VehicleLoaded(
        cars: repo.cars,
        motorcycles: repo.motorcycles,
        trucks: repo.trucks,
      ));
    } on DioException catch (e) {
      _handleDioError(e, emit);
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  // =========================
  // DELETE
  // =========================
  Future<void> _onDelete(
      DeleteVehicleEvent event, Emitter<VehicleState> emit) async {
    if (state is! VehicleLoaded) return;

    try {
      await repo.deleteById(event.id, event.type);

      emit(VehicleLoaded(
        cars: repo.cars,
        motorcycles: repo.motorcycles,
        trucks: repo.trucks,
      ));
    } on DioException catch (e) {
      _handleDioError(e, emit);
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  // =========================
  // ERROR HANDLER
  // =========================
  void _handleDioError(DioException e, Emitter<VehicleState> emit) {
    if (e.type == DioExceptionType.connectionError) {
      emit(NetworkUnavailableState());
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      emit(TimeoutState("Request timed out"));
    } else if (e.response != null) {
      emit(ServerErrorState(
          "Server error: ${e.response?.statusCode}"));
    } else {
      emit(VehicleError("Unexpected network error"));
    }
  }
}