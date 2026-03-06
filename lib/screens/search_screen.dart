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
}