import '../enums/gear_type.dart';
import 'engine.dart';

class Automobile {
  String _manufactureCompany = '';
  DateTime _manufactureDate = DateTime.now();
  String _model = '';
  Engine _engine = Engine();
  int _plateNum = 0;
  GearType _gearType = GearType.normal;

  // لازم يكون قابل للعرض والتعديل (حسب المطلوب)
  int _bodySerialNum = 0;

  // Default constructor (zero-argument)
  Automobile();

  // Full constructor
  Automobile.full(
    this._manufactureCompany,
    this._manufactureDate,
    this._model,
    this._engine,
    this._plateNum,
    this._gearType,
    this._bodySerialNum,
  );

  // Getters/Setters
  String get manufactureCompany => _manufactureCompany;
  set manufactureCompany(String v) => _manufactureCompany = v;

  DateTime get manufactureDate => _manufactureDate;
  set manufactureDate(DateTime v) => _manufactureDate = v;

  String get model => _model;
  set model(String v) => _model = v;

  Engine get engine => _engine;
  set engine(Engine v) => _engine = v;

  int get plateNum => _plateNum;
  set plateNum(int v) => _plateNum = v;

  GearType get gearType => _gearType;
  set gearType(GearType v) => _gearType = v;

  int get bodySerialNum => _bodySerialNum;
  set bodySerialNum(int v) => _bodySerialNum = v;

  // JSON
  Map<String, dynamic> toJson() => {
        'manufactureCompany': _manufactureCompany,
        'manufactureDate': _manufactureDate.toIso8601String(),
        'model': _model,
        'engine': _engine.toJson(),
        'plateNum': _plateNum,
        'gearType': _gearType.name,
        'bodySerialNum': _bodySerialNum,
      };

  factory Automobile.fromJson(Map<String, dynamic> json) => Automobile.full(
        (json['manufactureCompany'] ?? '') as String,
        DateTime.parse(json['manufactureDate'] as String),
        (json['model'] ?? '') as String,
        Engine.fromJson((json['engine'] as Map).cast<String, dynamic>()),
        (json['plateNum'] ?? 0) as int,
        GearType.values.firstWhere((e) => e.name == json['gearType']),
        (json['bodySerialNum'] ?? 0) as int,
      );
}