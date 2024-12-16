import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/country_model.dart';

class CountryService {
  Future<List<Country>> fetchCountries() async {
    try {
      final String response = await rootBundle.loadString('assets/countries.json');
      final List<dynamic> data = json.decode(response);

      // Map JSON to Country list
      return data.map((json) => Country.fromJson(json)).toList();
    } catch (e) {
      print("Error loading countries: $e");
      return [];
    }
  }
}
