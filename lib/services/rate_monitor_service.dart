import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rate_alert.dart';

class RateAlertService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createRateAlert({
    required String uid,
    required String baseCurrency,
    required String targetCurrency,
    required double thresholdAmount,
    required bool isAbove,
  }) async {
    try {
      await _firestore.collection('rate_alerts').add({
        'uid': uid,
        'baseCurrency': baseCurrency,
        'targetCurrency': targetCurrency,
        'thresholdAmount': thresholdAmount,
        'isAbove': isAbove,
        'createdAt': FieldValue.serverTimestamp(),
        'isEnabled': true,
      });
    } catch (e) {
      throw Exception('Failed to create rate alert: $e');
    }
  }

  Stream<List<RateAlert>> getUserAlerts(String uid) {
    return _firestore
        .collection('rate_alerts')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RateAlert.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> toggleAlertStatus(String alertId, bool isEnabled) async {
    try {
      await _firestore
          .collection('rate_alerts')
          .doc(alertId)
          .update({'isEnabled': isEnabled});
    } catch (e) {
      throw Exception('Failed to update alert status: $e');
    }
  }

  Future<void> deleteAlert(String alertId) async {
    try {
      await _firestore.collection('rate_alerts').doc(alertId).delete();
    } catch (e) {
      throw Exception('Failed to delete alert: $e');
    }
  }
}