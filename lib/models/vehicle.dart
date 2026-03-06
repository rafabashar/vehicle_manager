import '../enums/gear_type.dart';
import 'automobile.dart';
import 'engine.dart';

class Vehicle extends Automobile {
  int _length = 0;
  int _width = 0;
  String _color = '';

  Vehicle();

  Vehicle.full(
    String manufactureCompany,
    DateTime manufactureDate,
    String model,
    Engine engine,
    int plateNum,
    GearType gearType,
    int bodySerialNum,
    this._length,
    this._width,
    this._color,
  ) : super.full(
          manufactureCompany,
          manufactureDate,
          model,
          engine,
          plateNum,
          gearType,
          bodySerialNum,
        );

  int get length => _length;
  set length(int v) => _length = v;

  int get width => _width;
  set width(int v) => _width = v;

  String get color => _color;
  set color(String v) => _color = v;

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'length': _length,
      'width': _width,
      'color': _color,
    });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle.full(
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
      );
}