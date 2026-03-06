import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/motorcycle.dart';
import '../models/truck.dart';

class VehicleCard extends StatelessWidget {
  final dynamic vehicle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onOpen;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.onDelete,
    required this.onEdit,
    required this.onOpen,
  });

  String _type(dynamic v) {
    if (v is Car) return 'Car';
    if (v is Truck) return 'Truck';
    return 'Motorcycle';
  }

  @override
  Widget build(BuildContext context) {
    final type = _type(vehicle);

    return Card(
      child: ListTile(
        onTap: onOpen,
        title: Text("$type • ${vehicle.model}"),
        subtitle: Text(
          "Company: ${vehicle.manufactureCompany} | Plate: ${vehicle.plateNum} | BodySN: ${vehicle.bodySerialNum}",
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
            IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}