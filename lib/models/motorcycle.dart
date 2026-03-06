import '../enums/gear_type.dart';
import 'automobile.dart';
import 'engine.dart';

class Motorcycle extends Automobile {
  double _tierDiameter = 0.0;
  double _length = 0.0;

  // Default constructor (zero-argument)
  Motorcycle();

  // Full constructor (includes parent params)
  Motorcycle.full(
    String manufactureCompany,
    DateTime manufactureDate,
    String model,
    Engine engine,
    int plateNum,
    GearType gearType,
    int bodySerialNum,
    this._tierDiameter,
    this._length,
  ) : super.full(
          manufactureCompany,
          manufactureDate,
          model,
          engine,
          plateNum,
          gearType,
          bodySerialNum,
        );

  double get tierDiameter => _tierDiameter;
  set tierDiameter(double v) => _tierDiameter = v;

  double get length => _length;
  set length(double v) => _length = v;

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'tierDiameter': _tierDiameter,
      'motoLength': _length,
    });

  factory Motorcycle.fromJson(Map<String, dynamic> json) => Motorcycle.full(
        (json['manufactureCompany'] ?? '') as String,
        DateTime.parse(json['manufactureDate'] as String),
        (json['model'] ?? '') as String,
        Engine.fromJson((json['engine'] as Map).cast<String, dynamic>()),
        (json['plateNum'] ?? 0) as int,
        GearType.values.firstWhere((e) => e.name == json['gearType']),
        (json['bodySerialNum'] ?? 0) as int,
        ((json['tierDiameter'] ?? 0) as num).toDouble(),
        ((json['motoLength'] ?? 0) as num).toDouble(),
      );
}