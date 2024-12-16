import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eproject/screens/auth/encrypted_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:eproject/utils/encryption_util.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      // First check if email exists in Firestore
      var userDoc = await _firestore
          .collection('users')
          .where('useremail', isEqualTo: email)
          .get();

      if (userDoc.docs.isEmpty) {
        return {
          'success': false,
          'message': 'No account found with this email. Please sign up first.',
        };
      }

      // Encrypt the provided password for comparison
      String encryptedPassword = EncryptionUtil.encryptPassword(password);

      try {
        // Sign in with Firebase Authentication
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: encryptedPassword,
        );

        if (userCredential.user != null) {
          if (!userCredential.user!.emailVerified) {
            return {
              'success': false,
              'message': 'Please verify your email before logging in.',
            };
          }

          var userData = userDoc.docs.first.data();
          
          // Store user data in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userName', userData['username']);
          await prefs.setString('userEmail', userData['useremail']);
          await prefs.setString('baseCurrencyPreference', 
              userData['setCurrencyPreference'] ?? 'USD');
          await prefs.setBool('isLoggedIn', true);

          return {
            'success': true,
            'message': 'Welcome back, ${userData['username']}!',
            'userData': userData,
          };
        } else {
          return {
            'success': false,
            'message': 'Login failed. Please try again.',
          };
        }
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'wrong-password':
            return {
              'success': false,
              'message': 'Incorrect password. Please try again.',
            };
          case 'user-disabled':
            return {
              'success': false,
              'message': 'This account has been disabled. Please contact support.',
            };
          case 'too-many-requests':
            return {
              'success': false,
              'message': 'Too many failed attempts. Please try again later.',
            };
          default:
            return {
              'success': false,
              'message': 'Login failed. Please check your credentials.',
            };
        }
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  Future<String> getCurrentUserName() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userName = prefs.getString('userName');
      if (userName != null && userName.isNotEmpty) {
        return userName;
      }
      
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        var userDoc = await _firestore
            .collection('users')
            .where('useremail', isEqualTo: currentUser.email)
            .get();
            
        if (userDoc.docs.isNotEmpty) {
          String username = userDoc.docs.first.data()['username'];
          await prefs.setString('userName', username);
          return username;
        }
      }
      return 'Guest';
    } catch (e) {
      print("Error getting username: $e");
      return 'Guest';
    }
  }
}