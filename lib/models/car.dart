import '../enums/gear_type.dart';
import 'engine.dart';
import 'vehicle.dart';

class Car extends Vehicle {
  int _chairNum = 0;
  bool _isFurnitureLeather = false;

  Car();

  Car.full(
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
    this._chairNum,
    this._isFurnitureLeather,
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

  int get chairNum => _chairNum;
  set chairNum(int v) => _chairNum = v;

  bool get isFurnitureLeather => _isFurnitureLeather;
  set isFurnitureLeather(bool v) => _isFurnitureLeather = v;

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'chairNum': _chairNum,
      'isFurnitureLeather': _isFurnitureLeather,
    });

  factory Car.fromJson(Map<String, dynamic> json) => Car.full(
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
        (json['chairNum'] ?? 0) as int,
        (json['isFurnitureLeather'] ?? false) as bool,
      );
}