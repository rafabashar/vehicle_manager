/*import '../enums/vehicle_type.dart';
import '../models/car.dart';
import '../models/motorcycle.dart';
import '../models/truck.dart';
import 'storage_service.dart';

class VehicleRepository {
  final StorageService storage;

  List<Car> cars = [];
  List<Motorcycle> motorcycles = [];
  List<Truck> trucks = [];

  VehicleRepository({required this.storage});

  Future<void> load() async {
    final data = await storage.loadAll();
    cars = data.cars;
    motorcycles = data.motorcycles;
    trucks = data.trucks;
  }

  Future<void> save() async {
    await storage.saveAll(cars: cars, motorcycles: motorcycles, trucks: trucks);
  }

  // -------- CRUD --------

  void addCar(Car c) => cars.add(c);
  void addMotorcycle(Motorcycle m) => motorcycles.add(m);
  void addTruck(Truck t) => trucks.add(t);

  void insertCar(int index, Car c) => cars.insert(index, c);
  void insertMotorcycle(int index, Motorcycle m) => motorcycles.insert(index, m);
  void insertTruck(int index, Truck t) => trucks.insert(index, t);

  void updateCar(Car updated) {
    final id = updated.plateNum.toString();
    final i = cars.indexWhere((c) => c.plateNum.toString() == id);
    if (i != -1) cars[i] = updated;
  }

  void updateMotorcycle(Motorcycle updated) {
    final id = updated.plateNum.toString();
    final i = motorcycles.indexWhere((m) => m.plateNum.toString() == id);
    if (i != -1) motorcycles[i] = updated;
  }

  void updateTruck(Truck updated) {
    final id = updated.plateNum.toString();
    final i = trucks.indexWhere((t) => t.plateNum.toString() == id);
    if (i != -1) trucks[i] = updated;
  }

  void deleteById(String id, VehicleType type) {
    if (type == VehicleType.car) {
      cars.removeWhere((c) => c.plateNum.toString() == id);
    } else if (type == VehicleType.motorcycle) {
      motorcycles.removeWhere((m) => m.plateNum.toString() == id);
    } else {
      trucks.removeWhere((t) => t.plateNum.toString() == id);
    }
  }

  void printAllConsole() {
  for (final c in cars) {
    print("Car: ${c.model} | Plate: ${c.plateNum}");
  }
  for (final m in motorcycles) {
    print("Motorcycle: ${m.model} | Plate: ${m.plateNum}");
  }
  for (final t in trucks) {
    print("Truck: ${t.model} | Plate: ${t.plateNum}");
  }
}
}*/


import 'package:dio/dio.dart';

import '../enums/vehicle_type.dart';
import '../models/car.dart';
import '../models/motorcycle.dart';
import '../models/truck.dart';
import '../services/storage_service.dart';
import '../services/vehicle_api_service.dart';

class VehicleRepository {
  final VehicleApiService apiService;
  final StorageService cacheService;

  List<Car> cars = [];
  List<Motorcycle> motorcycles = [];
  List<Truck> trucks = [];

  VehicleRepository({
    required this.apiService,
    required this.cacheService,
  });

  // =========================
  // LOAD FROM API + CACHE
  // =========================
  Future<void> load({int page = 1, int limit = 20}) async {
    try {
      final data = await apiService.fetchVehicles(page: page, limit: limit);

      cars = data.cars;
      motorcycles = data.motorcycles;
      trucks = data.trucks;

      // save successful response as offline cache
      await cacheService.saveAll(
        cars: cars,
        motorcycles: motorcycles,
        trucks: trucks,
      );
    } on DioException catch (e) {
      // network down -> fallback to cache
      if (_isConnectionError(e) || _isTimeoutError(e)) {
        final cached = await cacheService.loadAll();
        cars = cached.cars;
        motorcycles = cached.motorcycles;
        trucks = cached.trucks;
        return;
      }

      // server / other dio errors
      rethrow;
    } catch (_) {
      // anything unexpected -> try cache as last fallback
      final cached = await cacheService.loadAll();
      cars = cached.cars;
      motorcycles = cached.motorcycles;
      trucks = cached.trucks;
    }
  }

  Future<void> saveCacheOnly() async {
    await cacheService.saveAll(
      cars: cars,
      motorcycles: motorcycles,
      trucks: trucks,
    );
  }

  // =========================
  // ADD
  // =========================
  Future<void> addCar(Car car) async {
    await apiService.addVehicle(
      vehicleJson: car.toJson(),
      type: VehicleType.car,
    );
    cars.add(car);
    await saveCacheOnly();
  }

  Future<void> addMotorcycle(Motorcycle motorcycle) async {
    await apiService.addVehicle(
      vehicleJson: motorcycle.toJson(),
      type: VehicleType.motorcycle,
    );
    motorcycles.add(motorcycle);
    await saveCacheOnly();
  }

  Future<void> addTruck(Truck truck) async {
    await apiService.addVehicle(
      vehicleJson: truck.toJson(),
      type: VehicleType.truck,
    );
    trucks.add(truck);
    await saveCacheOnly();
  }

  // =========================
  // INSERT
  // =========================
  Future<void> insertCar(int index, Car car) async {
    await apiService.addVehicle(
      vehicleJson: car.toJson(),
      type: VehicleType.car,
    );

    final safeIndex = index.clamp(0, cars.length);
    cars.insert(safeIndex, car);
    await saveCacheOnly();
  }

  Future<void> insertMotorcycle(int index, Motorcycle motorcycle) async {
    await apiService.addVehicle(
      vehicleJson: motorcycle.toJson(),
      type: VehicleType.motorcycle,
    );

    final safeIndex = index.clamp(0, motorcycles.length);
    motorcycles.insert(safeIndex, motorcycle);
    await saveCacheOnly();
  }

  Future<void> insertTruck(int index, Truck truck) async {
    await apiService.addVehicle(
      vehicleJson: truck.toJson(),
      type: VehicleType.truck,
    );

    final safeIndex = index.clamp(0, trucks.length);
    trucks.insert(safeIndex, truck);
    await saveCacheOnly();
  }

  // =========================
  // UPDATE
  // =========================
  Future<void> updateCar(Car updated) async {
    final id = updated.plateNum.toString();

    await apiService.updateVehicle(
      id: id,
      vehicleJson: updated.toJson(),
      type: VehicleType.car,
    );

    final i = cars.indexWhere((c) => c.plateNum.toString() == id);
    if (i != -1) {
      cars[i] = updated;
      await saveCacheOnly();
    }
  }

  Future<void> updateMotorcycle(Motorcycle updated) async {
    final id = updated.plateNum.toString();

    await apiService.updateVehicle(
      id: id,
      vehicleJson: updated.toJson(),
      type: VehicleType.motorcycle,
    );

    final i = motorcycles.indexWhere((m) => m.plateNum.toString() == id);
    if (i != -1) {
      motorcycles[i] = updated;
      await saveCacheOnly();
    }
  }

  Future<void> updateTruck(Truck updated) async {
    final id = updated.plateNum.toString();

    await apiService.updateVehicle(
      id: id,
      vehicleJson: updated.toJson(),
      type: VehicleType.truck,
    );

    final i = trucks.indexWhere((t) => t.plateNum.toString() == id);
    if (i != -1) {
      trucks[i] = updated;
      await saveCacheOnly();
    }
  }

  // =========================
  // DELETE
  // =========================
  Future<void> deleteById(String id, VehicleType type) async {
    await apiService.deleteVehicle(id: id, type: type);

    if (type == VehicleType.car) {
      cars.removeWhere((c) => c.plateNum.toString() == id);
    } else if (type == VehicleType.motorcycle) {
      motorcycles.removeWhere((m) => m.plateNum.toString() == id);
    } else {
      trucks.removeWhere((t) => t.plateNum.toString() == id);
    }

    await saveCacheOnly();
  }

  // =========================
  // OPTIONAL: FULL REFRESH
  // =========================
  Future<void> refreshFromApi() async {
    await load();
  }

  // =========================
  // DEBUG
  // =========================
  void printAllConsole() {
    for (final c in cars) {
      print("Car: ${c.model} | Plate: ${c.plateNum}");
    }
    for (final m in motorcycles) {
      print("Motorcycle: ${m.model} | Plate: ${m.plateNum}");
    }
    for (final t in trucks) {
      print("Truck: ${t.model} | Plate: ${t.plateNum}");
    }
  }

  // =========================
  // HELPERS
  // =========================
  bool _isConnectionError(DioException e) {
    return e.type == DioExceptionType.connectionError;
  }

  bool _isTimeoutError(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout;
  }
}

