import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConverterController {
  Future<void> updateUserPreference(String currencyCode) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'setPreference': currencyCode});

      print("User preference updated successfully.");
    } catch (e) {
      print("Error updating user preference: $e");
    }
  } else {
    print("User not authenticated.");
  }
}
}