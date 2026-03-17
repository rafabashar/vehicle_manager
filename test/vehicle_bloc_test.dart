// test/vehicle_bloc_test.dart

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

  // Lists mutable نرجعها للـ repo
  late List<Car> cars;
  late List motorcycles;
  late List trucks;

  setUp(() {
    repo = MockVehicleRepository();

    cars = <Car>[];
    motorcycles = <dynamic>[];
    trucks = <dynamic>[];

    // getters ترجع نفس ال lists
    when(() => repo.cars).thenReturn(cars);
    when(() => repo.motorcycles).thenReturn(motorcycles);
    when(() => repo.trucks).thenReturn(trucks);

    // save/load افتراضي
    when(() => repo.load()).thenAnswer((_) async {});
    when(() => repo.save()).thenAnswer((_) async {});
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
    build: () => VehicleBloc(repo),
    act: (bloc) => bloc.add(LoadVehiclesEvent()),
    expect: () => [
      isA<VehicleLoading>(),
      isA<VehicleLoaded>(),
    ],
  );

  blocTest<VehicleBloc, VehicleState>(
    'AddVehicleEvent adds a car and emits VehicleLoaded',
    build: () {
      // addCar يحط بالـ list
      when(() => repo.addCar(any<Car>())).thenAnswer((inv) {
        cars.add(inv.positionalArguments.first as Car);
      });
      return VehicleBloc(repo);
    },
    seed: () => VehicleLoaded(cars: cars, motorcycles: const [], trucks: const []),
    act: (bloc) => bloc.add(AddVehicleEvent(sampleCar(), VehicleType.car)),
    wait: const Duration(milliseconds: 50),
    expect: () => [
      isA<VehicleLoaded>(),
    ],
    verify: (_) {
      verify(() => repo.addCar(any<Car>())).called(1);
      verify(() => repo.save()).called(1);
      expect(cars.length, 1);
    },
  );

  blocTest<VehicleBloc, VehicleState>(
    'DeleteVehicleEvent deletes a car and emits VehicleLoaded',
    build: () {
      // deleteById يمسح من list (حسب plateNum string)
      when(() => repo.deleteById(any<String>(), any<VehicleType>())).thenAnswer((inv) {
        final id = inv.positionalArguments[0] as String;
        cars.removeWhere((c) => c.plateNum.toString() == id);
      });
      return VehicleBloc(repo);
    },
    setUp: () {
      // نحط عنصر بالبداية
      cars.add(sampleCar());
    },
    seed: () => VehicleLoaded(cars: cars, motorcycles: const [], trucks: const []),
    act: (bloc) => bloc.add(const DeleteVehicleEvent("123", VehicleType.car)),
    wait: const Duration(milliseconds: 50),
    expect: () => [
      isA<VehicleLoaded>(),
    ],
    verify: (_) {
      verify(() => repo.deleteById("123", VehicleType.car)).called(1);
      verify(() => repo.save()).called(1);
      expect(cars.length, 0);
    },
  );
}