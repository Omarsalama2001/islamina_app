// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:islamina_app/core/error/exeptions.dart';
// import 'package:islamina_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
// import 'package:islamina_app/features/auth/data/models/user_data_model.dart';

// abstract class RemoteDataSource {
//   Future<UserModel> login({required bool isGoogle});

//   Future<Unit> logOut();
// }

// class RemoteDataSourceImpl extends RemoteDataSource {
//   LocalDataSource localDataSource;
//   FirebaseAuth firebaseAuth;

//   FirebaseFirestore firestore;

//   RemoteDataSourceImpl({
//     required this.localDataSource,
//     required this.firebaseAuth,
//     required this.firestore,
//   });
//   @override
//   Future<UserCredential> signInWithGoogle() async {
//     // Trigger the authentication flow
//     final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ['email', 'profile']).signIn();
//     // Obtain the auth details from the request
//     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

//     // Create a new credential
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken,
//       idToken: googleAuth?.idToken,
//     );

//     // Once signed in, return the UserCredential
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
//   @override
//   Future<Unit> logOut() async {
//     try {
//       await firebaseAuth.signOut();
//       return Future.value(unit);
//     } on FirebaseException {
//       throw (ServerException());
//     }
//   }

//   @override
//   Future<UserModel> login({required bool isGoogle}) {
//     throw UnimplementedError();
//   }

//   // Future<UserCredential> signInWithFacebook() async {
//   //   // have some problems here
//   //   // Trigger the sign-in flow
//   //   final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['public_profile']);

//   //   // Create a credential from the access token
//   //   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

//   //   // Once signed in, return the UserCredential
//   //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
//   // }
// }
