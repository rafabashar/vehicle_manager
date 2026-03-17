import '../models/automobile.dart';
import 'vehicle_repository.dart';

class SearchService {
  final VehicleRepository repo;
  SearchService(this.repo);

  List<Automobile> byCompany(String q) {
    final s = q.trim().toLowerCase();
    final res = <Automobile>[];
    res.addAll(repo.cars.where((v) => v.manufactureCompany.toLowerCase().contains(s)));
    res.addAll(repo.trucks.where((v) => v.manufactureCompany.toLowerCase().contains(s)));
    res.addAll(repo.motorcycles.where((v) => v.manufactureCompany.toLowerCase().contains(s)));
    return res;
  }

  List<Automobile> byPlate(int plate) {
    final res = <Automobile>[];
    res.addAll(repo.cars.where((v) => v.plateNum == plate));
    res.addAll(repo.trucks.where((v) => v.plateNum == plate));
    res.addAll(repo.motorcycles.where((v) => v.plateNum == plate));
    return res;
  }

  bool _sameDate(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  List<Automobile> byDate(DateTime date) {
    final res = <Automobile>[];
    res.addAll(repo.cars.where((v) => _sameDate(v.manufactureDate, date)));
    res.addAll(repo.trucks.where((v) => _sameDate(v.manufactureDate, date)));
    res.addAll(repo.motorcycles.where((v) => _sameDate(v.manufactureDate, date)));
    return res;
  }
}