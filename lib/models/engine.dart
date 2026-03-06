import '../enums/fuel_type.dart';

class Engine {
  String _manufacture = '';
  DateTime _manufactureDate = DateTime.now();
  String _model = '';
  int _capacity = 0;
  int _cylinders = 0;
  FuelType _fuelType = FuelType.gasoline;

  Engine();

  Engine.full(
    this._manufacture,
    this._manufactureDate,
    this._model,
    this._capacity,
    this._cylinders,
    this._fuelType,
  );

  String get manufacture => _manufacture;
  set manufacture(String v) => _manufacture = v;

  DateTime get manufactureDate => _manufactureDate;
  set manufactureDate(DateTime v) => _manufactureDate = v;

  String get model => _model;
  set model(String v) => _model = v;

  int get capacity => _capacity;
  set capacity(int v) => _capacity = v;

  int get cylinders => _cylinders;
  set cylinders(int v) => _cylinders = v;

  FuelType get fuelType => _fuelType;
  set fuelType(FuelType v) => _fuelType = v;

  Map<String, dynamic> toJson() => {
        'manufacture': _manufacture,
        'manufactureDate': _manufactureDate.toIso8601String(),
        'model': _model,
        'capacity': _capacity,
        'cylinders': _cylinders,
        'fuelType': _fuelType.name,
      };

  factory Engine.fromJson(Map<String, dynamic> json) => Engine.full(
        (json['manufacture'] ?? '') as String,
        DateTime.parse(json['manufactureDate'] as String),
        (json['model'] ?? '') as String,
        (json['capacity'] ?? 0) as int,
        (json['cylinders'] ?? 0) as int,
        FuelType.values.firstWhere((e) => e.name == json['fuelType']),
      );
}