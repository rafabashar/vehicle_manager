/*
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/car.dart';
import '../models/motorcycle.dart';
import '../models/truck.dart';

class StorageService {
  static const _kCars = 'cars_json';
  static const _kMotos = 'motos_json';
  static const _kTrucks = 'trucks_json';

  Future<void> saveAll({
    required List<Car> cars,
    required List<Motorcycle> motorcycles,
    required List<Truck> trucks,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCars, jsonEncode(cars.map((e) => e.toJson()).toList()));
    await prefs.setString(_kMotos, jsonEncode(motorcycles.map((e) => e.toJson()).toList()));
    await prefs.setString(_kTrucks, jsonEncode(trucks.map((e) => e.toJson()).toList()));
  }

  Future<({List<Car> cars, List<Motorcycle> motorcycles, List<Truck> trucks})> loadAll() async {
    final prefs = await SharedPreferences.getInstance();

    final carsStr = prefs.getString(_kCars);
    final motosStr = prefs.getString(_kMotos);
    final trucksStr = prefs.getString(_kTrucks);

    List<Car> cars = [];
    List<Motorcycle> motos = [];
    List<Truck> trucks = [];

    if (carsStr != null && carsStr.isNotEmpty) {
      final list = (jsonDecode(carsStr) as List).cast<Map>();
      cars = list.map((m) => Car.fromJson(m.cast<String, dynamic>())).toList();
    }

    if (motosStr != null && motosStr.isNotEmpty) {
      final list = (jsonDecode(motosStr) as List).cast<Map>();
      motos = list.map((m) => Motorcycle.fromJson(m.cast<String, dynamic>())).toList();
    }

    if (trucksStr != null && trucksStr.isNotEmpty) {
      final list = (jsonDecode(trucksStr) as List).cast<Map>();
      trucks = list.map((m) => Truck.fromJson(m.cast<String, dynamic>())).toList();
    }

    return (cars: cars, motorcycles: motos, trucks: trucks);
  }
}*/


import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/car.dart';
import '../models/motorcycle.dart';
import '../models/truck.dart';

class StorageService {
  static const _kCars = 'cars_json';
  static const _kMotos = 'motos_json';
  static const _kTrucks = 'trucks_json';

  // =========================
  // SAVE CACHE
  // =========================
  Future<void> saveAll({
    required List<Car> cars,
    required List<Motorcycle> motorcycles,
    required List<Truck> trucks,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _kCars,
      jsonEncode(cars.map((e) => e.toJson()).toList()),
    );

    await prefs.setString(
      _kMotos,
      jsonEncode(motorcycles.map((e) => e.toJson()).toList()),
    );

    await prefs.setString(
      _kTrucks,
      jsonEncode(trucks.map((e) => e.toJson()).toList()),
    );
  }

  // =========================
  // LOAD CACHE (FALLBACK)
  // =========================
  Future<({List<Car> cars, List<Motorcycle> motorcycles, List<Truck> trucks})>
      loadAll() async {
    final prefs = await SharedPreferences.getInstance();

    final carsStr = prefs.getString(_kCars);
    final motosStr = prefs.getString(_kMotos);
    final trucksStr = prefs.getString(_kTrucks);

    List<Car> cars = [];
    List<Motorcycle> motos = [];
    List<Truck> trucks = [];

    if (carsStr != null && carsStr.isNotEmpty) {
      final list = (jsonDecode(carsStr) as List).cast<Map>();
      cars = list
          .map((m) => Car.fromJson(m.cast<String, dynamic>()))
          .toList();
    }

    if (motosStr != null && motosStr.isNotEmpty) {
      final list = (jsonDecode(motosStr) as List).cast<Map>();
      motos = list
          .map((m) => Motorcycle.fromJson(m.cast<String, dynamic>()))
          .toList();
    }

    if (trucksStr != null && trucksStr.isNotEmpty) {
      final list = (jsonDecode(trucksStr) as List).cast<Map>();
      trucks = list
          .map((m) => Truck.fromJson(m.cast<String, dynamic>()))
          .toList();
    }

    return (cars: cars, motorcycles: motos, trucks: trucks);
  }
}