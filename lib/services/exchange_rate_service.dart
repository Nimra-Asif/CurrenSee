import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRateService {
  static const String _apiKey = '84ac3955af9b49259fcbccbe550ab04b';
  static const String _baseUrl = 'https://openexchangerates.org/api';

  Future<Map<String, double>> fetchRates() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/latest.json?app_id=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Map<String, double>.from(data['rates']);
      } else {
        throw Exception('Failed to fetch exchange rates');
      }
    } catch (e) {
      throw Exception('Error fetching rates: $e');
    }
  }

  Future<double> getRate(String baseCurrency, String targetCurrency) async {
    try {
      final rates = await fetchRates();
      
      if (!rates.containsKey(baseCurrency) || !rates.containsKey(targetCurrency)) {
        throw Exception('Currency not found');
      }

      if (baseCurrency == targetCurrency) return 1.0;

      final baseRate = rates[baseCurrency]!;
      final targetRate = rates[targetCurrency]!;
      
      return targetRate / baseRate;
    } catch (e) {
      throw Exception('Error calculating rate: $e');
    }
  }

  bool isThresholdMet(double currentRate, double thresholdRate, bool isAbove) {
    return isAbove ? currentRate >= thresholdRate : currentRate <= thresholdRate;
  }
}