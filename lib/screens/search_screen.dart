/*

import 'package:flutter/material.dart';
import '../services/vehicle_manager.dart';
import 'vehicle_details_screen.dart';

enum SearchMode { company, date, plate }

class SearchScreen extends StatefulWidget {
  final VehicleManager manager;
  const SearchScreen({super.key, required this.manager});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchMode mode = SearchMode.company;
  final textCtrl = TextEditingController();
  DateTime date = DateTime.now();
  List<dynamic> results = [];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      initialDate: date,
    );
    if (picked != null) setState(() => date = picked);
  }

  void _search() {
    if (mode == SearchMode.company) {
      results = widget.manager.searchByCompany(textCtrl.text);
    } else if (mode == SearchMode.plate) {
      results = widget.manager.searchByPlate(int.tryParse(textCtrl.text) ?? 0);
    } else {
      results = widget.manager.searchByDate(date);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<SearchMode>(
              value: mode,
              decoration: const InputDecoration(labelText: "Search By"),
              items: const [
                DropdownMenuItem(value: SearchMode.company, child: Text("Manufacture Company Name")),
                DropdownMenuItem(value: SearchMode.date, child: Text("Manufacture Date")),
                DropdownMenuItem(value: SearchMode.plate, child: Text("Plate Number")),
              ],
              onChanged: (v) => setState(() => mode = v!),
            ),
            const SizedBox(height: 12),
            if (mode == SearchMode.date)
              OutlinedButton(
                onPressed: _pickDate,
                child: Text("Pick Date: ${date.year}-${date.month}-${date.day}"),
              )
            else
              TextField(
                controller: textCtrl,
                keyboardType: mode == SearchMode.plate ? TextInputType.number : TextInputType.text,
                decoration: InputDecoration(
                  labelText: mode == SearchMode.company ? "Company Name" : "Plate Number",
                ),
              ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _search, child: const Text("Search")),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (_, i) {
                  final v = results[i];
                  return Card(
                    child: ListTile(
                      title: Text(v.model),
                      subtitle: Text("Company: ${v.manufactureCompany} | Plate: ${v.plateNum} | BodySN: ${v.bodySerialNum}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => VehicleDetailsScreen(vehicle: v)),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';

import 'vehicle_details_screen.dart';

enum SearchModeUi { company, date, plate }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchModeUi mode = SearchModeUi.company;
  final textCtrl = TextEditingController();
  DateTime date = DateTime.now();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      initialDate: date,
    );
    if (picked != null) setState(() => date = picked);
  }

  void _search() {
    final bloc = context.read<SearchBloc>();

    if (mode == SearchModeUi.company) {
      bloc.add(SearchByCompanyEvent(textCtrl.text));
    } else if (mode == SearchModeUi.plate) {
      bloc.add(SearchByPlateEvent(int.tryParse(textCtrl.text) ?? 0));
    } else {
      bloc.add(SearchByDateEvent(date));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        actions: [
          IconButton(
            onPressed: () => context.read<SearchBloc>().add(ClearSearchEvent()),
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<SearchModeUi>(
              value: mode,
              decoration: const InputDecoration(labelText: "Search By"),
              items: const [
                DropdownMenuItem(value: SearchModeUi.company, child: Text("Manufacture Company Name")),
                DropdownMenuItem(value: SearchModeUi.date, child: Text("Manufacture Date")),
                DropdownMenuItem(value: SearchModeUi.plate, child: Text("Plate Number")),
              ],
              onChanged: (v) => setState(() => mode = v!),
            ),
            const SizedBox(height: 12),
            if (mode == SearchModeUi.date)
              OutlinedButton(
                onPressed: _pickDate,
                child: Text("Pick Date: ${date.year}-${date.month}-${date.day}"),
              )
            else
              TextField(
                controller: textCtrl,
                keyboardType: mode == SearchModeUi.plate ? TextInputType.number : TextInputType.text,
                decoration: InputDecoration(
                  labelText: mode == SearchModeUi.company ? "Company Name" : "Plate Number",
                ),
              ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _search, child: const Text("Search")),
            const SizedBox(height: 12),

            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return const Center(child: Text("Enter a query to search."));
                  }
                  if (state is SearchEmpty) {
                    return const Center(child: Text("No results."));
                  }
                  if (state is SearchResults) {
                    return ListView.builder(
                      itemCount: state.results.length,
                      itemBuilder: (_, i) {
                        final v = state.results[i];
                        return Card(
                          child: ListTile(
                            title: Text(v.model),
                            subtitle: Text("Company: ${v.manufactureCompany} | Plate: ${v.plateNum} | BodySN: ${v.bodySerialNum}"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => VehicleDetailsScreen(vehicle: v)),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}