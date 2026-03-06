import 'package:flutter/material.dart';

import '../services/vehicle_manager.dart';
import '../services/storage_service.dart';

import '../models/engine.dart';
import '../models/car.dart';
import '../models/truck.dart';
import '../models/motorcycle.dart';

import '../enums/fuel_type.dart';
import '../enums/gear_type.dart';

class AddVehicleScreen extends StatefulWidget {
  final VehicleManager manager;
  final StorageService storage;

  final bool isEdit;
  final String? editType; // car | motorcycle | truck
  final int? editIndex;
  final dynamic editVehicle;

  const AddVehicleScreen({
    super.key,
    required this.manager,
    required this.storage,
    this.isEdit = false,
    this.editType,
    this.editIndex,
    this.editVehicle,
  });

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  String selectedType = "car";

  bool insertAtPosition = false;
  final indexCtrl = TextEditingController(text: "0");

  // Automobile
  final companyCtrl = TextEditingController();
  final modelCtrl = TextEditingController();
  final plateCtrl = TextEditingController();
  final bodySerialCtrl = TextEditingController();
  DateTime autoDate = DateTime.now();
  GearType gearType = GearType.normal;

  // Engine
  final engManCtrl = TextEditingController();
  final engModelCtrl = TextEditingController();
  final engCapacityCtrl = TextEditingController();
  final engCylCtrl = TextEditingController();
  DateTime engDate = DateTime.now();
  FuelType fuelType = FuelType.gasoline;

  // Vehicle (car/truck)
  final vLengthCtrl = TextEditingController();
  final vWidthCtrl = TextEditingController();
  final vColorCtrl = TextEditingController();

  // Car
  final chairCtrl = TextEditingController();
  bool leather = false;

  // Motorcycle
  final tierCtrl = TextEditingController();
  final motoLenCtrl = TextEditingController();

  // Truck
  final freeWCtrl = TextEditingController();
  final fullWCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.editVehicle != null) {
      selectedType = widget.editType ?? "car";
      _fillForEdit(widget.editVehicle);
    }
  }

  void _fillForEdit(dynamic v) {
    companyCtrl.text = v.manufactureCompany.toString();
    modelCtrl.text = v.model.toString();
    plateCtrl.text = v.plateNum.toString();
    bodySerialCtrl.text = v.bodySerialNum.toString();
    autoDate = v.manufactureDate as DateTime;
    gearType = v.gearType as GearType;

    final e = v.engine as Engine;
    engManCtrl.text = e.manufacture;
    engModelCtrl.text = e.model;
    engCapacityCtrl.text = e.capacity.toString();
    engCylCtrl.text = e.cylinders.toString();
    engDate = e.manufactureDate;
    fuelType = e.fuelType;

    if (v is Car || v is Truck) {
      vLengthCtrl.text = v.length.toString();
      vWidthCtrl.text = v.width.toString();
      vColorCtrl.text = v.color.toString();
    }

    if (v is Car) {
      chairCtrl.text = v.chairNum.toString();
      leather = v.isFurnitureLeather;
    }

    if (v is Motorcycle) {
      tierCtrl.text = v.tierDiameter.toString();
      motoLenCtrl.text = v.length.toString();
    }

    if (v is Truck) {
      freeWCtrl.text = v.freeWeight.toString();
      fullWCtrl.text = v.fullWeight.toString();
    }
  }

  Future<void> _pickDate({
    required DateTime current,
    required void Function(DateTime) onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      initialDate: current,
    );
    if (picked != null) onPicked(picked);
  }

  int _i(TextEditingController c) => int.tryParse(c.text.trim()) ?? 0;
  double _d(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0.0;
  String _s(TextEditingController c) => c.text.trim();

  Engine _buildEngine() => Engine.full(
        _s(engManCtrl),
        engDate,
        _s(engModelCtrl),
        _i(engCapacityCtrl),
        _i(engCylCtrl),
        fuelType,
      );

  Future<void> _save() async {
    final engine = _buildEngine();

    final company = _s(companyCtrl);
    final model = _s(modelCtrl);
    final plate = _i(plateCtrl);
    final bodySN = _i(bodySerialCtrl);

    final idx = _i(indexCtrl);

    if (selectedType == "motorcycle") {
      final m = Motorcycle.full(
        company,
        autoDate,
        model,
        engine,
        plate,
        gearType,
        bodySN,
        _d(tierCtrl),
        _d(motoLenCtrl),
      );

      if (widget.isEdit) {
        widget.manager.updateMotorcycle(widget.editIndex!, m);
      } else {
        if (insertAtPosition) {
          widget.manager.insertMotorcycle(idx.clamp(0, widget.manager.motorcycles.length), m);
        } else {
          widget.manager.addMotorcycle(m);
        }
      }
    }

    if (selectedType == "car") {
      final c = Car.full(
        company,
        autoDate,
        model,
        engine,
        plate,
        gearType,
        bodySN,
        _i(vLengthCtrl),
        _i(vWidthCtrl),
        _s(vColorCtrl),
        _i(chairCtrl),
        leather,
      );

      if (widget.isEdit) {
        widget.manager.updateCar(widget.editIndex!, c);
      } else {
        if (insertAtPosition) {
          widget.manager.insertCar(idx.clamp(0, widget.manager.cars.length), c);
        } else {
          widget.manager.addCar(c);
        }
      }
    }

    if (selectedType == "truck") {
      final t = Truck.full(
        company,
        autoDate,
        model,
        engine,
        plate,
        gearType,
        bodySN,
        _i(vLengthCtrl),
        _i(vWidthCtrl),
        _s(vColorCtrl),
        _d(freeWCtrl),
        _d(fullWCtrl),
      );

      if (widget.isEdit) {
        widget.manager.updateTruck(widget.editIndex!, t);
      } else {
        if (insertAtPosition) {
          widget.manager.insertTruck(idx.clamp(0, widget.manager.trucks.length), t);
        } else {
          widget.manager.addTruck(t);
        }
      }
    }

    await widget.storage.saveAll(
      cars: widget.manager.cars,
      motorcycles: widget.manager.motorcycles,
      trucks: widget.manager.trucks,
    );

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Vehicle" : "Add Vehicle"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(labelText: "Vehicle Type"),
              items: const [
                DropdownMenuItem(value: "car", child: Text("Car")),
                DropdownMenuItem(value: "motorcycle", child: Text("Motorcycle")),
                DropdownMenuItem(value: "truck", child: Text("Truck")),
              ],
              onChanged: widget.isEdit ? null : (v) => setState(() => selectedType = v!),
            ),
            const SizedBox(height: 16),
            if (!widget.isEdit)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text("Insert at specific position"),
                        value: insertAtPosition,
                        onChanged: (v) => setState(() => insertAtPosition = v),
                      ),
                      if (insertAtPosition)
                        TextField(
                          controller: indexCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Index"),
                        ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            _section("Automobile"),
            TextField(controller: companyCtrl, decoration: const InputDecoration(labelText: "Manufacture Company")),
            TextField(controller: modelCtrl, decoration: const InputDecoration(labelText: "Model")),
            TextField(controller: plateCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Plate Number")),
            TextField(controller: bodySerialCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Body Serial Number (editable)")),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _pickDate(current: autoDate, onPicked: (d) => setState(() => autoDate = d)),
              child: Text("Manufacture Date: ${autoDate.year}-${autoDate.month}-${autoDate.day}"),
            ),
            DropdownButtonFormField<GearType>(
              value: gearType,
              decoration: const InputDecoration(labelText: "Gear Type"),
              items: GearType.values.map((g) => DropdownMenuItem(value: g, child: Text(g.name))).toList(),
              onChanged: (v) => setState(() => gearType = v!),
            ),

            const SizedBox(height: 16),

            _section("Engine"),
            TextField(controller: engManCtrl, decoration: const InputDecoration(labelText: "Engine Manufacture")),
            TextField(controller: engModelCtrl, decoration: const InputDecoration(labelText: "Engine Model")),
            TextField(controller: engCapacityCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Capacity")),
            TextField(controller: engCylCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Cylinders")),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _pickDate(current: engDate, onPicked: (d) => setState(() => engDate = d)),
              child: Text("Engine Date: ${engDate.year}-${engDate.month}-${engDate.day}"),
            ),
            DropdownButtonFormField<FuelType>(
              value: fuelType,
              decoration: const InputDecoration(labelText: "Fuel Type"),
              items: FuelType.values.map((f) => DropdownMenuItem(value: f, child: Text(f.name))).toList(),
              onChanged: (v) => setState(() => fuelType = v!),
            ),

            const SizedBox(height: 16),

            if (selectedType == "car" || selectedType == "truck") ...[
              _section("Vehicle"),
              TextField(controller: vLengthCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Length (int)")),
              TextField(controller: vWidthCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Width (int)")),
              TextField(controller: vColorCtrl, decoration: const InputDecoration(labelText: "Color")),
              const SizedBox(height: 16),
            ],

            if (selectedType == "motorcycle") ...[
              _section("Motorcycle"),
              TextField(controller: tierCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Tier Diameter (double)")),
              TextField(controller: motoLenCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Length (double)")),
              const SizedBox(height: 16),
            ],

            if (selectedType == "car") ...[
              _section("Car"),
              TextField(controller: chairCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Chair Number (int)")),
              SwitchListTile(
                title: const Text("Is Furniture Leather"),
                value: leather,
                onChanged: (v) => setState(() => leather = v),
              ),
              const SizedBox(height: 16),
            ],

            if (selectedType == "truck") ...[
              _section("Truck"),
              TextField(controller: freeWCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Free Weight (double)")),
              TextField(controller: fullWCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Full Weight (double)")),
              const SizedBox(height: 16),
            ],

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _save,
                    child: Text(widget.isEdit ? "Save Changes" : "Save"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String t) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      );
}