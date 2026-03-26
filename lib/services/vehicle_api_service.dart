import 'package:dio/dio.dart';
import '../enums/vehicle_type.dart';
import '../models/car.dart';
import '../models/motorcycle.dart';
import '../models/truck.dart';

class VehicleApiResponse {
  final List<Car> cars;
  final List<Motorcycle> motorcycles;
  final List<Truck> trucks;

  VehicleApiResponse({
    required this.cars,
    required this.motorcycles,
    required this.trucks,
  });
}

class VehicleApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://69c556f78a5b6e2dec2c3dd7.mockapi.io/api/v1", // ✏️ عدلي هذا لاحقًا حسب API
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // =========================
  // GET ALL (PAGINATED)
  // =========================
  Future<VehicleApiResponse> fetchVehicles({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(
  "/vehicles",
  queryParameters: {
    "page": page,
    "limit": limit,
  },
);

print("API DATA: ${response.data}");

    final data = response.data;

    final List<Car> cars = [];
    final List<Motorcycle> motorcycles = [];
    final List<Truck> trucks = [];

    for (var item in data) {
      final type = item['type'];

      if (type == 'car') {
        cars.add(Car.fromJson(item));
      } else if (type == 'motorcycle') {
        motorcycles.add(Motorcycle.fromJson(item));
      } else if (type == 'truck') {
        trucks.add(Truck.fromJson(item));
      }
    }

    return VehicleApiResponse(
      cars: cars,
      motorcycles: motorcycles,
      trucks: trucks,
    );
  }

  // =========================
  // ADD
  // =========================
  Future<void> addVehicle({
    required Map<String, dynamic> vehicleJson,
    required VehicleType type,
  }) async {
    final data = {
      ...vehicleJson,
      "type": _mapType(type),
    };

    await _dio.post(
      "/vehicles",
      data: data,
    );
  }

  // =========================
  // UPDATE
  // =========================
  Future<void> updateVehicle({
    required String id,
    required Map<String, dynamic> vehicleJson,
    required VehicleType type,
  }) async {
    final data = {
      ...vehicleJson,
      "type": _mapType(type),
    };

    await _dio.put(
      "/vehicles/$id",
      data: data,
    );
  }

  // =========================
  // DELETE
  // =========================
  Future<void> deleteVehicle({
    required String id,
    required VehicleType type,
  }) async {
    await _dio.delete("/vehicles/$id");
  }

  // =========================
  // HELPERS
  // =========================
  String _mapType(VehicleType type) {
    switch (type) {
      case VehicleType.car:
        return "car";
      case VehicleType.motorcycle:
        return "motorcycle";
      case VehicleType.truck:
        return "truck";
    }
  }
}