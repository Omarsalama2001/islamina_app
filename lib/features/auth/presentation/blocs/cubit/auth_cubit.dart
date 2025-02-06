import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:islamina_app/core/constants/cache_keys.dart';
import 'package:islamina_app/core/network/network_info.dart';
import 'package:islamina_app/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  AuthCubit() : super(AuthInitial());
  static final SharedPreferences prefs = SharedPreferencesService.instance.prefs;
  InternetConnectionChecker internetConnectionChecker = InternetConnectionChecker();

  login() async {
    emit(AuthLoading());

    await signInWithGoogle();
  }

  Future<void> signInWithGoogle() async {
    if (await internetConnectionChecker.hasConnection) {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ['email', 'profile']).signIn();
        final GoogleSignInAuthentication googleSignInAuthentication = await googleUser!.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          saveToken(token: user.uid);
          emit(AuthSuccess());
        } else {
          emit(const AuthError(message: "something went wrong, try again later"));
        }
      } catch (e) {
        emit(const AuthError(message: "something went wrong, try again later"));
      }
    } else {
      emit(const AuthError(message: "No internet connection"));
    }
  }

  void saveToken({required String token}) async {
    await prefs.setString(TOKENID_KEY, token);
  }

  @override
  static void removeToken() async {
    await prefs.remove(TOKENID_KEY);
    FirebaseAuth.instance.signOut();
  }
}
