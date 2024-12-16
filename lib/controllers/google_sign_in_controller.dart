// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eproject/models/user_model.dart';
// import 'package:eproject/screens/main/loader.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// // final GoogleSignIn googleSignIn = GoogleSignIn(
// //     clientId:
// //         '919740703819-h0vlmg778s7f2i8bhs62l46rnavtpbdh.apps.googleusercontent.com',
// //   );
// class GoogleSignInController {
//   final GoogleSignIn googleSignIn = GoogleSignIn(
//     clientId: Platform.isIOS
//         ? '919740703819-h0vlmg778s7f2i8bhs62l46rnavtpbdh.apps.googleusercontent.com' // iOS Client ID
//         : '919740703819-po5ho7ivpcakv2boj6891uuq5v2elnan.apps.googleusercontent.com', // Android/Web Client ID
//   );

//   Future<bool> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signInSilently();

//       if (googleSignInAccount != null) {
//         Loader(); // Show loader during sign-in
//         final GoogleSignInAuthentication googleSignInAuthentication =
//             await googleSignInAccount.authentication;

//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleSignInAuthentication.accessToken,
//           idToken: googleSignInAuthentication.idToken,
//         );

//         final UserCredential userCredential =
//             await FirebaseAuth.instance.signInWithCredential(credential);

//         final User? user = userCredential.user;

//         if (user != null) {
//           // Save user data in Firestore
//           UserModel userModel = UserModel(
//             uId: user.uid,
//             username: user.displayName.toString(),
//             email: user.email.toString(),
//             createdAt: DateTime.now(),
//           );

//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(user.uid)
//               .set(userModel.toMap());

//           return true;
//         }
//       }
//       return false;
//     } catch (e) {
//       print('Error during Google Sign-In: $e');
//       return false;
//     }
//   }
// }