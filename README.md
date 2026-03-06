````md
# Vehicle Management System (Flutter + Dart OOP)

## Project Title
Vehicle Management System

## Description
A Flutter application that manages three types of vehicles: **Cars**, **Motorcycles**, and **Trucks**.  
The app allows the user to **add**, **insert at a specific position**, **edit**, **delete**, and **search** vehicles.  
All data is stored locally using **JSON serialization** and is loaded automatically when the app starts.

## Features
- Add new vehicles (**Motorcycle / Car / Truck**) using a single **Add Vehicle** flow
- Insert vehicles at a specific index (optional during adding)
- Modify existing vehicle data using a pre-filled edit form
- Delete vehicles
- Search by:
  - Manufacture Company Name
  - Manufacture Date
  - Plate Number
- Display functions:
  - Print a single vehicle info (**Motorcycle / Car / Truck**)
  - Print all vehicles from all lists
- Save lists locally using JSON
- Load saved data automatically on app start

## OOP Concepts Used
This project applies core **Object-Oriented Programming (OOP)** concepts in Dart:

### 1) Encapsulation
- All fields are private (prefixed with `_`)
- Access to data is controlled using **getters and setters**

### 2) Inheritance
- `Motorcycle` extends `Automobile`
- `Vehicle` extends `Automobile`
- `Car` extends `Vehicle`
- `Truck` extends `Vehicle`

### 3) Polymorphism
- Different vehicle types share common properties through the base class (`Automobile`)
- Each type adds its own specialized fields and behavior
- JSON serialization (`toJson` / `fromJson`) is implemented separately for each class

### 4) Constructors
Each class includes:
- A default constructor
- A full constructor with all parameters, including inherited fields

## Classes Included

### Enums
- `FuelType` (`diesel`, `gasoline`)
- `GearType` (`normal`, `automatic`)

### Models
- `Engine`
- `Automobile`
- `Vehicle`
- `Motorcycle`
- `Car`
- `Truck`

### Services
- `VehicleManager` → Handles lists, CRUD operations, search, and print functions
- `StorageService` → Handles saving and loading data using JSON

### Screens
- `HomeScreen` → Main screen with tabs for Cars, Motorcycles, and Trucks
- `AddVehicleScreen` → Dynamic form for adding/editing vehicles and optional insert index
- `SearchScreen` → Search filters and results
- `VehicleDetailsScreen` → Displays detailed information for a single vehicle
- `AllVehiclesScreen` → Displays all vehicles grouped by type

## Project Structure
```text
lib/
├── enums/
│   ├── fuel_type.dart
│   └── gear_type.dart
├── models/
│   ├── automobile.dart
│   ├── car.dart
│   ├── engine.dart
│   ├── motorcycle.dart
│   ├── truck.dart
│   └── vehicle.dart
├── services/
│   ├── storage_service.dart
│   └── vehicle_manager.dart
├── screens/
│   ├── home_screen.dart
│   ├── add_vehicle_screen.dart
│   ├── search_screen.dart
│   ├── vehicle_details_screen.dart
│   └── all_vehicles_screen.dart
├── widgets/
│   └── vehicle_card.dart
└── main.dart
````

## Requirements

* Flutter SDK installed
* VS Code (recommended) + Flutter extension
* Chrome (for web) or Android Emulator / phone (for mobile)

## How to Run

### Steps

1. Clone or download the project
2. Open the project folder in VS Code
3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

5. If running on web:

```bash
flutter run -d chrome
```

## Screenshots

### Home Screen

![Home Screen](assets/screenshots/home.png)

### Search Screen

![Search Screen](assets/screenshots/search.png)

### Add Vehicle Screen

![Add Screen](assets/screenshots/add.png)

## Author

Developed by Rafah Bashar

```

إذا بدك، أرتبلك كمان **تعليق التسليم الجاهز لتريلو بالإنجليزي**.
```
