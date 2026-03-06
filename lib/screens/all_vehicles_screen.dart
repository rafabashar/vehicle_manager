import 'package:flutter/material.dart';
import '../services/vehicle_manager.dart';
import '../widgets/vehicle_card.dart';
import 'vehicle_details_screen.dart';

class AllVehiclesScreen extends StatelessWidget {
  final VehicleManager manager;
  const AllVehiclesScreen({super.key, required this.manager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Vehicles")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text("Cars", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ...manager.cars.map((v) => VehicleCard(
                vehicle: v,
                onOpen: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleDetailsScreen(vehicle: v))),
                onEdit: () {},
                onDelete: () {},
              )),
          const SizedBox(height: 12),
          const Text("Motorcycles", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ...manager.motorcycles.map((v) => VehicleCard(
                vehicle: v,
                onOpen: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleDetailsScreen(vehicle: v))),
                onEdit: () {},
                onDelete: () {},
              )),
          const SizedBox(height: 12),
          const Text("Trucks", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ...manager.trucks.map((v) => VehicleCard(
                vehicle: v,
                onOpen: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleDetailsScreen(vehicle: v))),
                onEdit: () {},
                onDelete: () {},
              )),
        ],
      ),
    );
  }
}