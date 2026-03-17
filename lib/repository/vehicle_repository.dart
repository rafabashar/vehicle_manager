import '../enums/vehicle_type.dart';
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
}