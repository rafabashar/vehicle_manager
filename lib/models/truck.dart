import '../enums/gear_type.dart';
import 'engine.dart';
import 'vehicle.dart';

class Truck extends Vehicle {
  double _freeWeight = 0;
  double _fullWeight = 0;

  Truck();

  Truck.full(
    String manufactureCompany,
    DateTime manufactureDate,
    String model,
    Engine engine,
    int plateNum,
    GearType gearType,
    int bodySerialNum,
    int length,
    int width,
    String color,
    this._freeWeight,
    this._fullWeight,
  ) : super.full(
          manufactureCompany,
          manufactureDate,
          model,
          engine,
          plateNum,
          gearType,
          bodySerialNum,
          length,
          width,
          color,
        );

  double get freeWeight => _freeWeight;
  set freeWeight(double v) => _freeWeight = v;

  double get fullWeight => _fullWeight;
  set fullWeight(double v) => _fullWeight = v;

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'freeWeight': _freeWeight,
      'fullWeight': _fullWeight,
    });

  factory Truck.fromJson(Map<String, dynamic> json) => Truck.full(
        (json['manufactureCompany'] ?? '') as String,
        DateTime.parse(json['manufactureDate'] as String),
        (json['model'] ?? '') as String,
        Engine.fromJson((json['engine'] as Map).cast<String, dynamic>()),
        (json['plateNum'] ?? 0) as int,
        GearType.values.firstWhere((e) => e.name == json['gearType']),
        (json['bodySerialNum'] ?? 0) as int,
        (json['length'] ?? 0) as int,
        (json['width'] ?? 0) as int,
        (json['color'] ?? '') as String,
        ((json['freeWeight'] ?? 0) as num).toDouble(),
        ((json['fullWeight'] ?? 0) as num).toDouble(),
      );
}