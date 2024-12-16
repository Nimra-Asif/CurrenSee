import 'package:cloud_firestore/cloud_firestore.dart';

class RateAlert {
  final String id;
  final String uid;
  final String baseCurrency;
  final String targetCurrency;
  final double thresholdAmount;
  final bool isAbove;
  final DateTime createdAt;
  final bool isEnabled;

  RateAlert({
    required this.id,
    required this.uid,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.thresholdAmount,
    required this.isAbove,
    required this.createdAt,
    this.isEnabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'thresholdAmount': thresholdAmount,
      'isAbove': isAbove,
      'createdAt': createdAt,
      'isEnabled': isEnabled,
    };
  }

  factory RateAlert.fromMap(String id, Map<String, dynamic> map) {
    return RateAlert(
      id: id,
      uid: map['uid'] ?? '',
      baseCurrency: map['baseCurrency'] ?? '',
      targetCurrency: map['targetCurrency'] ?? '',
      thresholdAmount: (map['thresholdAmount'] ?? 0.0).toDouble(),
      isAbove: map['isAbove'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isEnabled: map['isEnabled'] ?? true,
    );
  }
}