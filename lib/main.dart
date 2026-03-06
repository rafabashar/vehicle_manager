import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/vehicle_manager.dart';
import 'services/storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = VehicleManager();
    final storage = StorageService();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(manager: manager, storage: storage),
    );
  }
}