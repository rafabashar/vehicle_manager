/*

import 'package:flutter/material.dart';

import '../services/vehicle_manager.dart';
import '../services/storage_service.dart';

import '../widgets/vehicle_card.dart';

import 'add_vehicle_screen.dart';
import 'search_screen.dart';
import 'vehicle_details_screen.dart';
import 'all_vehicles_screen.dart';

class HomeScreen extends StatefulWidget {
  final VehicleManager manager;
  final StorageService storage;

  const HomeScreen({
    super.key,
    required this.manager,
    required this.storage,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await widget.storage.loadAll();
    widget.manager.cars = data.cars;
    widget.manager.motorcycles = data.motorcycles;
    widget.manager.trucks = data.trucks;

    setState(() => loading = false);
  }

  Future<void> _save() async {
    await widget.storage.saveAll(
      cars: widget.manager.cars,
      motorcycles: widget.manager.motorcycles,
      trucks: widget.manager.trucks,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved")),
      );
    }
  }

  Future<void> _openAdd({String? editType, int? editIndex, dynamic editVehicle}) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddVehicleScreen(
          manager: widget.manager,
          storage: widget.storage,
          isEdit: editVehicle != null,
          editType: editType,
          editIndex: editIndex,
          editVehicle: editVehicle,
        ),
      ),
    );

    if (changed == true) {
      setState(() {});
      await _save();
    }
  }

  Future<void> _openSearch() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(manager: widget.manager),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Vehicle Manager"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Cars"),
              Tab(text: "Motorcycles"),
              Tab(text: "Trucks"),
            ],
          ),
          actions: [
            IconButton(
              tooltip: "Print All (Console)",
              onPressed: () => widget.manager.printAll(),
              icon: const Icon(Icons.print),
            ),
            IconButton(
              tooltip: "All Vehicles",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllVehiclesScreen(manager: widget.manager),
                  ),
                );
              },
              icon: const Icon(Icons.view_list),
            ),
            IconButton(
              tooltip: "Search",
              onPressed: _openSearch,
              icon: const Icon(Icons.search),
            ),
            IconButton(
              tooltip: "Add Vehicle",
              onPressed: () => _openAdd(),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Cars
            ListView.builder(
              itemCount: widget.manager.cars.length,
              itemBuilder: (context, i) {
                final car = widget.manager.cars[i];
                return VehicleCard(
                  vehicle: car,
                  onOpen: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VehicleDetailsScreen(vehicle: car),
                      ),
                    );
                  },
                  onEdit: () => _openAdd(editType: "car", editIndex: i, editVehicle: car),
                  onDelete: () async {
                    setState(() => widget.manager.deleteCar(i));
                    await _save();
                  },
                );
              },
            ),

            // Motorcycles
            ListView.builder(
              itemCount: widget.manager.motorcycles.length,
              itemBuilder: (context, i) {
                final m = widget.manager.motorcycles[i];
                return VehicleCard(
                  vehicle: m,
                  onOpen: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VehicleDetailsScreen(vehicle: m),
                      ),
                    );
                  },
                  onEdit: () => _openAdd(editType: "motorcycle", editIndex: i, editVehicle: m),
                  onDelete: () async {
                    setState(() => widget.manager.deleteMotorcycle(i));
                    await _save();
                  },
                );
              },
            ),

            // Trucks
            ListView.builder(
              itemCount: widget.manager.trucks.length,
              itemBuilder: (context, i) {
                final t = widget.manager.trucks[i];
                return VehicleCard(
                  vehicle: t,
                  onOpen: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VehicleDetailsScreen(vehicle: t),
                      ),
                    );
                  },
                  onEdit: () => _openAdd(editType: "truck", editIndex: i, editVehicle: t),
                  onDelete: () async {
                    setState(() => widget.manager.deleteTruck(i));
                    await _save();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} */


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/vehicle/vehicle_bloc.dart';
import '../bloc/vehicle/vehicle_event.dart';
import '../bloc/vehicle/vehicle_state.dart';

import '../enums/vehicle_type.dart';

import '../widgets/vehicle_card.dart';

import 'add_vehicle_screen.dart';
import 'search_screen.dart';
import 'vehicle_details_screen.dart';
import 'all_vehicles_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openAdd(BuildContext context, {String? editType, dynamic editVehicle}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddVehicleScreen(
          isEdit: editVehicle != null,
          editType: editType,
          editVehicle: editVehicle,
        ),
      ),
    );
  }

  void _openSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Vehicle Manager"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Cars"),
              Tab(text: "Motorcycles"),
              Tab(text: "Trucks"),
            ],
          ),
          actions: [
            IconButton(
              tooltip: "Print All (Console)",
              onPressed: () => context.read<VehicleBloc>().repo.printAllConsole(),
              icon: const Icon(Icons.print),
            ),
            IconButton(
              tooltip: "All Vehicles",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AllVehiclesScreen()),
                );
              },
              icon: const Icon(Icons.view_list),
            ),
            IconButton(
              tooltip: "Search",
              onPressed: () => _openSearch(context),
              icon: const Icon(Icons.search),
            ),
            IconButton(
              tooltip: "Add Vehicle",
              onPressed: () => _openAdd(context),
              icon: const Icon(Icons.add),
            ),
          ],
        ),

        body: BlocBuilder<VehicleBloc, VehicleState>(
          builder: (context, state) {
            if (state is VehicleLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is VehicleError) {
              return Center(child: Text(state.message));
            }

            if (state is! VehicleLoaded) {
              return const SizedBox.shrink();
            }

            return TabBarView(
              children: [
                // Cars
                ListView.builder(
                  itemCount: state.cars.length,
                  itemBuilder: (context, i) {
                    final car = state.cars[i];
                    return VehicleCard(
                      vehicle: car,
                      onOpen: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => VehicleDetailsScreen(vehicle: car)),
                        );
                      },
                      onEdit: () => _openAdd(context, editType: "car", editVehicle: car),
                      onDelete: () {
                        context.read<VehicleBloc>().add(
                              DeleteVehicleEvent(car.plateNum.toString(), VehicleType.car),
                            );
                      },
                    );
                  },
                ),

                // Motorcycles
                ListView.builder(
                  itemCount: state.motorcycles.length,
                  itemBuilder: (context, i) {
                    final m = state.motorcycles[i];
                    return VehicleCard(
                      vehicle: m,
                      onOpen: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => VehicleDetailsScreen(vehicle: m)),
                        );
                      },
                      onEdit: () => _openAdd(context, editType: "motorcycle", editVehicle: m),
                      onDelete: () {
                        context.read<VehicleBloc>().add(
                              DeleteVehicleEvent(m.plateNum.toString(), VehicleType.motorcycle),
                            );
                      },
                    );
                  },
                ),

                // Trucks
                ListView.builder(
                  itemCount: state.trucks.length,
                  itemBuilder: (context, i) {
                    final t = state.trucks[i];
                    return VehicleCard(
                      vehicle: t,
                      onOpen: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => VehicleDetailsScreen(vehicle: t)),
                        );
                      },
                      onEdit: () => _openAdd(context, editType: "truck", editVehicle: t),
                      onDelete: () {
                        context.read<VehicleBloc>().add(
                              DeleteVehicleEvent(t.plateNum.toString(), VehicleType.truck),
                            );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}