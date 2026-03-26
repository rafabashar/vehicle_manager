/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/vehicle/vehicle_bloc.dart';
import 'bloc/vehicle/vehicle_event.dart';
import 'bloc/search/search_bloc.dart';
import 'bloc/persistence/persistence_bloc.dart';

import 'services/storage_service.dart';
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
} */


//      home: HomeScreen(manager: manager, storage: storage),

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/vehicle/vehicle_bloc.dart';
import 'bloc/vehicle/vehicle_event.dart';
import 'bloc/search/search_bloc.dart';
import 'bloc/persistence/persistence_bloc.dart';

import 'repository/vehicle_repository.dart';
import 'repository/search_service.dart';
import 'services/storage_service.dart';
import 'services/vehicle_api_service.dart';

import 'screens/home_screen.dart';
import 'screens/dashboard_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final cacheService = StorageService();
  final apiService = VehicleApiService();
  final repo = VehicleRepository(
    apiService: apiService,
    cacheService: cacheService,
  );
  final searchService = SearchService(repo);

  runApp(MyApp(
    repo: repo,
    searchService: searchService,
  ));
}

class MyApp extends StatelessWidget {
  final VehicleRepository repo;
  final SearchService searchService;

  const MyApp({
    super.key,
    required this.repo,
    required this.searchService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VehicleBloc>(
          create: (_) => VehicleBloc(repo)..add(LoadVehiclesEvent()),
        ),
        BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(searchService),
        ),
        BlocProvider<PersistenceBloc>(
          create: (_) => PersistenceBloc(repo),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DashboardPage(),
      ),
    );
  }
}