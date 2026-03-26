import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/vehicle/vehicle_bloc.dart';
import '../bloc/vehicle/vehicle_event.dart';
import '../bloc/vehicle/vehicle_state.dart';

import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';

import '../models/automobile.dart';
import 'vehicle_details_screen.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NetworkUnavailableState) {
            return const Center(child: Text("No Internet Connection"));
          }

          if (state is TimeoutState) {
            return const Center(child: Text("Request Timeout"));
          }

          if (state is ServerErrorState) {
            return Center(child: Text(state.message));
          }

          if (state is VehicleLoaded) {
            final allVehicles = [
              ...state.cars,
              ...state.trucks,
              ...state.motorcycles,
            ];

            return RefreshIndicator(
              onRefresh: () async {
                context.read<VehicleBloc>().add(LoadVehiclesEvent());
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSummary(state),
                  const SizedBox(height: 20),
                  _buildSearch(context),
                  const SizedBox(height: 20),
                  _buildList(context, allVehicles),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // =========================
  // SUMMARY BAR
  // =========================
  Widget _buildSummary(VehicleLoaded state) {
    final total =
        state.cars.length + state.trucks.length + state.motorcycles.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statCard("Total", total),
        _statCard("Cars", state.cars.length),
        _statCard("Trucks", state.trucks.length),
        _statCard("Motos", state.motorcycles.length),
      ],
    );
  }

  Widget _statCard(String title, int value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("$value"),
          ],
        ),
      ),
    );
  }

  // =========================
  // SEARCH
  // =========================
  Widget _buildSearch(BuildContext context) {
    final controller = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Search by company",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            context
                .read<SearchBloc>()
                .add(SearchByCompanyEvent(controller.text));
          },
          child: const Text("Search"),
        ),
        const SizedBox(height: 10),

        // نتائج البحث
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchInitial) {
              return const SizedBox();
            }

            if (state is SearchEmpty) {
              return const Text("No results");
            }

            if (state is SearchResults) {
              return Column(
                children: state.results
                    .map((v) => _vehicleTile(context, v))
                    .toList(),
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }

  // =========================
  // VEHICLE LIST
  // =========================
  Widget _buildList(
      BuildContext context, List<Automobile> vehicles) {
    if (vehicles.isEmpty) {
      return const Center(child: Text("No vehicles"));
    }

    return Column(
      children: vehicles
          .map((v) => _vehicleTile(context, v))
          .toList(),
    );
  }

  // =========================
  // TILE
  // =========================
  Widget _vehicleTile(BuildContext context, Automobile v) {
    return Card(
      child: ListTile(
        title: Text(v.model),
        subtitle: Text("Plate: ${v.plateNum}"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VehicleDetailsScreen(vehicle: v),
            ),
          );
        },
      ),
    );
  }
}