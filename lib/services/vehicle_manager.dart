import '../models/car.dart';
import '../models/motorcycle.dart';
import '../models/truck.dart';

class VehicleManager {
  List<Motorcycle> motorcycles = [];
  List<Car> cars = [];
  List<Truck> trucks = [];

  // ADD
  void addMotorcycle(Motorcycle m) => motorcycles.add(m);
  void addCar(Car c) => cars.add(c);
  void addTruck(Truck t) => trucks.add(t);

  // INSERT
  void insertMotorcycle(int index, Motorcycle m) => motorcycles.insert(index, m);
  void insertCar(int index, Car c) => cars.insert(index, c);
  void insertTruck(int index, Truck t) => trucks.insert(index, t);

  // DELETE
  void deleteMotorcycle(int index) => motorcycles.removeAt(index);
  void deleteCar(int index) => cars.removeAt(index);
  void deleteTruck(int index) => trucks.removeAt(index);

  // UPDATE (replace object)
  void updateMotorcycle(int index, Motorcycle m) => motorcycles[index] = m;
  void updateCar(int index, Car c) => cars[index] = c;
  void updateTruck(int index, Truck t) => trucks[index] = t;

  // SEARCH
  List<dynamic> searchByCompany(String name) {
    final q = name.trim().toLowerCase();
    final res = <dynamic>[];
    res.addAll(cars.where((v) => v.manufactureCompany.toLowerCase().contains(q)));
    res.addAll(trucks.where((v) => v.manufactureCompany.toLowerCase().contains(q)));
    res.addAll(motorcycles.where((v) => v.manufactureCompany.toLowerCase().contains(q)));
    return res;
  }

  List<dynamic> searchByPlate(int plate) {
    final res = <dynamic>[];
    res.addAll(cars.where((v) => v.plateNum == plate));
    res.addAll(trucks.where((v) => v.plateNum == plate));
    res.addAll(motorcycles.where((v) => v.plateNum == plate));
    return res;
  }

  bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<dynamic> searchByDate(DateTime date) {
    final res = <dynamic>[];
    res.addAll(cars.where((v) => _sameDate(v.manufactureDate, date)));
    res.addAll(trucks.where((v) => _sameDate(v.manufactureDate, date)));
    res.addAll(motorcycles.where((v) => _sameDate(v.manufactureDate, date)));
    return res;
  }

  // PRINT METHODS (Console) - required
  void printMotorcycle(Motorcycle m) {
    print("Motorcycle Info: ${m.model}, Plate Number: ${m.plateNum}, Tier Diameter: ${m.tierDiameter}, Length: ${m.length}");
  }

  void printCar(Car c) {
    print("Car Info: ${c.model}, Plate Number: ${c.plateNum}, Color: ${c.color}, Chairs: ${c.chairNum}, Leather: ${c.isFurnitureLeather}");
  }

  void printTruck(Truck t) {
    print("Truck Info: ${t.model}, Plate Number: ${t.plateNum}, Free Weight: ${t.freeWeight}, Full Weight: ${t.fullWeight}");
  }

  void printAll() {
    for (final m in motorcycles) printMotorcycle(m);
    for (final c in cars) printCar(c);
    for (final t in trucks) printTruck(t);
  }
}