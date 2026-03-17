import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/vehicle/vehicle_bloc.dart';
import 'bloc/vehicle/vehicle_event.dart';
import 'bloc/search/search_bloc.dart';
import 'bloc/persistence/persistence_bloc.dart';

import 'repository/storage_service.dart';
import 'repository/vehicle_repository.dart';
import 'repository/search_service.dart';
import 'screens/home_screen.dart';

void main() {
  final storage = StorageService();
  final repo = VehicleRepository(storage: storage);
  final searchService = SearchService(repo);

  runApp(MyApp(repo: repo, searchService: searchService));
}

class MyApp extends StatelessWidget {
  final VehicleRepository repo;
  final SearchService searchService;

  const MyApp({super.key, required this.repo, required this.searchService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => VehicleBloc(repo)..add(LoadVehiclesEvent()), // ✅ load at startup
        ),
        BlocProvider(
          create: (_) => SearchBloc(searchService),
        ),
        BlocProvider(
          create: (_) => PersistenceBloc(repo),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(), // سنعدلها لتستخدم BlocBuilder
      ),
    );
  }
}


//      home: HomeScreen(manager: manager, storage: storage),
