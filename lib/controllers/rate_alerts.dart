import 'package:cloud_firestore/cloud_firestore.dart';

class RateAlerts {
  final String uid;
  final String baseCurrency;
  final String targetCurrency;
  final double thresholdAmount;
  final bool isAbove;
  final String createdAt;

  RateAlerts(
      {required this.uid,
      required this.baseCurrency,
      required this.targetCurrency,
      required this.thresholdAmount,
      required this.isAbove,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'thresholdAmount': thresholdAmount,
      'isAbove': isAbove,
      'createdAt': createdAt,
    };
  }

    static Future<void> saveRateAlert({
    required String uid,
    required String baseCurrency,
    required String targetCurrency,
    required double thresholdAmount,
    required bool isAbove,
  }) async {
    final rateAlert = {
      'uid': uid,
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'thresholdAmount': thresholdAmount,
      'isAbove': isAbove,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      final collection = FirebaseFirestore.instance.collection('rate_alerts');
      await collection.add(rateAlert);
    } catch (e) {
      print('Failed to save rate alert: $e');
    }
  }
}
