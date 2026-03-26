// test/vehicle_bloc_test.dart

/*import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:vehicle_manager/bloc/vehicle/vehicle_bloc.dart';
import 'package:vehicle_manager/bloc/vehicle/vehicle_event.dart';
import 'package:vehicle_manager/bloc/vehicle/vehicle_state.dart';

import 'package:vehicle_manager/enums/vehicle_type.dart';
import 'package:vehicle_manager/enums/fuel_type.dart';
import 'package:vehicle_manager/enums/gear_type.dart';

import 'package:vehicle_manager/models/engine.dart';
import 'package:vehicle_manager/models/car.dart';

import 'package:vehicle_manager/repository/vehicle_repository.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class CarFake extends Fake implements Car {}

void main() {
  setUpAll(() {
    // Required by mocktail for any<Car>() and any<VehicleType>()
    registerFallbackValue(CarFake());
    registerFallbackValue(VehicleType.car);
  });

  late MockVehicleRepository repo;

  setUp(() {
    repo = MockVehicleRepository();
  });

  Car sampleCar() {
    final engine = Engine.full(
      "Toyota",
      DateTime(2020, 1, 1),
      "V6",
      2000,
      6,
      FuelType.gasoline,
    );

    return Car.full(
      "Toyota",
      DateTime(2020, 2, 2),
      "Corolla",
      engine,
      123,
      GearType.normal,
      999,
      400,
      180,
      "Red",
      5,
      true,
    );
  }

  blocTest<VehicleBloc, VehicleState>(
    'LoadVehiclesEvent emits VehicleLoading then VehicleLoaded',
    build: () {
      when(() => repo.load()).thenAnswer((_) async {});
      when(() => repo.cars).thenReturn([]);
      when(() => repo.motorcycles).thenReturn([]);
      when(() => repo.trucks).thenReturn([]);
      return VehicleBloc(repo);
    },
    act: (bloc) => bloc.add(LoadVehiclesEvent()),
    expect: () => [
      isA<VehicleLoading>(),
      isA<VehicleLoaded>(),
    ],
  );

  blocTest<VehicleBloc, VehicleState>(
    'AddVehicleEvent adds a car and emits VehicleLoaded',
    build: () {
      when(() => repo.saveCacheOnly()).thenAnswer((_) async {});
      when(() => repo.cars).thenReturn([]);
      when(() => repo.motorcycles).thenReturn([]);
      when(() => repo.trucks).thenReturn([]);
      when(() => repo.addCar(any<Car>())).thenAnswer((_) {});
      return VehicleBloc(repo);
    },
    seed: () => const VehicleLoaded(cars: [], motorcycles: [], trucks: []),
    act: (bloc) => bloc.add(AddVehicleEvent(sampleCar(), VehicleType.car)),
    expect: () => [
      isA<VehicleLoaded>(),
    ],
    verify: (_) {
      verify(() => repo.addCar(any<Car>())).called(1);
      verify(() => repo.saveCacheOnly()).called(1);
    },
  );

  blocTest<VehicleBloc, VehicleState>(
    'DeleteVehicleEvent deletes a car and emits VehicleLoaded',
    build: () {
      when(() => repo.saveCacheOnly()).thenAnswer((_) async {});
      when(() => repo.cars).thenReturn([]);
      when(() => repo.motorcycles).thenReturn([]);
      when(() => repo.trucks).thenReturn([]);
      when(() => repo.deleteById(any<String>(), any<VehicleType>())).thenAnswer((_) {});
      return VehicleBloc(repo);
    },
    seed: () => const VehicleLoaded(cars: [], motorcycles: [], trucks: []),
    act: (bloc) => bloc.add(const DeleteVehicleEvent("123", VehicleType.car)),
    expect: () => [
      isA<VehicleLoaded>(),
    ],
    verify: (_) {
      verify(() => repo.deleteById("123", VehicleType.car)).called(1);
      verify(() => repo.saveCacheOnly()).called(1);
    },
  );
} */

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:vehicle_manager/bloc/vehicle/vehicle_bloc.dart';
import 'package:vehicle_manager/bloc/vehicle/vehicle_event.dart';
import 'package:vehicle_manager/bloc/vehicle/vehicle_state.dart';

import 'package:vehicle_manager/enums/vehicle_type.dart';
import 'package:vehicle_manager/enums/fuel_type.dart';
import 'package:vehicle_manager/enums/gear_type.dart';

import 'package:vehicle_manager/models/engine.dart';
import 'package:vehicle_manager/models/car.dart';

import 'package:vehicle_manager/repository/vehicle_repository.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class CarFake extends Fake implements Car {}

void main() {
  setUpAll(() {
    registerFallbackValue(CarFake());
    registerFallbackValue(VehicleType.car);
  });

  late MockVehicleRepository repo;

  setUp(() {
    repo = MockVehicleRepository();
  });

  Car sampleCar() {
    final engine = Engine.full(
      "Toyota",
      DateTime(2020, 1, 1),
      "V6",
      2000,
      6,
      FuelType.gasoline,
    );

    return Car.full(
      "Toyota",
      DateTime(2020, 2, 2),
      "Corolla",
      engine,
      123,
      GearType.normal,
      999,
      400,
      180,
      "Red",
      5,
      true,
    );
  }

  // =========================
  // LOAD TEST
  // =========================
  blocTest<VehicleBloc, VehicleState>(
    'LoadVehiclesEvent emits VehicleLoading then VehicleLoaded',
    build: () {
      when(() => repo.load()).thenAnswer((_) async {});
      when(() => repo.cars).thenReturn([]);
      when(() => repo.motorcycles).thenReturn([]);
      when(() => repo.trucks).thenReturn([]);
      return VehicleBloc(repo);
    },
    act: (bloc) => bloc.add(LoadVehiclesEvent()),
    expect: () => [
      isA<VehicleLoading>(),
      isA<VehicleLoaded>(),
    ],
  );

  // =========================
  // ADD TEST
  // =========================
  blocTest<VehicleBloc, VehicleState>(
    'AddVehicleEvent adds a car and emits VehicleLoaded',
    build: () {
      when(() => repo.saveCacheOnly()).thenAnswer((_) async {});
      when(() => repo.cars).thenReturn([]);
      when(() => repo.motorcycles).thenReturn([]);
      when(() => repo.trucks).thenReturn([]);
      when(() => repo.addCar(any<Car>())).thenAnswer((_) async {});
      return VehicleBloc(repo);
    },
    seed: () => const VehicleLoaded(
      cars: [],
      motorcycles: [],
      trucks: [],
    ),
    act: (bloc) =>
        bloc.add(AddVehicleEvent(sampleCar(), VehicleType.car)),
    expect: () => [
      isA<VehicleLoaded>(),
    ],
    verify: (_) {
      verify(() => repo.addCar(any<Car>())).called(1);
      verify(() => repo.saveCacheOnly()).called(1);
    },
  );

  // =========================
  // DELETE TEST
  // =========================
  blocTest<VehicleBloc, VehicleState>(
    'DeleteVehicleEvent deletes a car and emits VehicleLoaded',
    build: () {
      when(() => repo.saveCacheOnly()).thenAnswer((_) async {});
      when(() => repo.cars).thenReturn([]);
      when(() => repo.motorcycles).thenReturn([]);
      when(() => repo.trucks).thenReturn([]);
      when(() => repo.deleteById(any<String>(), any<VehicleType>()))
          .thenAnswer((_) async {});
      return VehicleBloc(repo);
    },
    seed: () => const VehicleLoaded(
      cars: [],
      motorcycles: [],
      trucks: [],
    ),
    act: (bloc) =>
        bloc.add(const DeleteVehicleEvent("123", VehicleType.car)),
    expect: () => [
      isA<VehicleLoaded>(),
    ],
    verify: (_) {
      verify(() => repo.deleteById("123", VehicleType.car)).called(1);
      verify(() => repo.saveCacheOnly()).called(1);
    },
  );
}