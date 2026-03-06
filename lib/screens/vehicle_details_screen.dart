import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/motorcycle.dart';
import '../models/truck.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final dynamic vehicle;
  const VehicleDetailsScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final isCar = vehicle is Car;
    final isTruck = vehicle is Truck;
    final isMoto = vehicle is Motorcycle;

    return Scaffold(
      appBar: AppBar(title: const Text("Vehicle Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _row("Type", isCar ? "Car" : isTruck ? "Truck" : "Motorcycle"),
            _row("Company", vehicle.manufactureCompany.toString()),
            _row("Model", vehicle.model.toString()),
            _row("Plate", vehicle.plateNum.toString()),
            _row("Body Serial", vehicle.bodySerialNum.toString()),
            _row("Manufacture Date", vehicle.manufactureDate.toString()),
            const Divider(),
            _row("Engine Manufacture", vehicle.engine.manufacture.toString()),
            _row("Engine Model", vehicle.engine.model.toString()),
            _row("Capacity", vehicle.engine.capacity.toString()),
            _row("Cylinders", vehicle.engine.cylinders.toString()),
            _row("FuelType", vehicle.engine.fuelType.name),
            const Divider(),
            if (isCar || isTruck) ...[
              _row("Vehicle Length", vehicle.length.toString()),
              _row("Vehicle Width", vehicle.width.toString()),
              _row("Color", vehicle.color.toString()),
              const Divider(),
            ],
            if (isCar) ...[
              _row("Chair Num", vehicle.chairNum.toString()),
              _row("Leather", vehicle.isFurnitureLeather.toString()),
            ],
            if (isTruck) ...[
              _row("Free Weight", vehicle.freeWeight.toString()),
              _row("Full Weight", vehicle.fullWeight.toString()),
            ],
            if (isMoto) ...[
              _row("Tier Diameter", vehicle.tierDiameter.toString()),
              _row("Length", vehicle.length.toString()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(child: Text(k, style: const TextStyle(fontWeight: FontWeight.bold))),
            Expanded(child: Text(v)),
          ],
        ),
      );
}