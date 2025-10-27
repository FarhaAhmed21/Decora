import 'package:decora/src/features/Auth/widgets/conflictDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  FirestoreService get firestoreService => _firestoreService;
  Future<User?> signUpWithEmail(
    String email,
    String password,
    String nameFromForm,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user != null) {
      await _firestoreService.saveUserData(
        UserModel(
          id: user.uid,
          email: user.email ?? '',
          name: nameFromForm,
          photoUrl: user.photoURL ?? '',
        ),
      );
    }

    return user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      await _firestoreService.saveUserData(
        UserModel(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          photoUrl: user.photoURL ?? '',
        ),
      );
    }

    return user;
  }

  Future<User?> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final facebookAuthCredential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        try {
          final userCredential = await _auth.signInWithCredential(
            facebookAuthCredential,
          );
          final user = userCredential.user;

          if (user != null) {
            await _firestoreService.saveUserData(
              UserModel(
                id: user.uid,
                email: user.email ?? '',
                name: user.displayName ?? '',
                photoUrl: user.photoURL ?? '',
              ),
            );
          }

          return user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            final email = e.email;
            final pendingCredential = e.credential;

            if (email == null) return null;

            final signInMethods = await _auth.fetchSignInMethodsForEmail(email);

            if (signInMethods.contains('google.com')) {
              showProviderConflictDialog(context);
              return null;
            } else if (signInMethods.isEmpty) {
              try {
                final userCredential = await _auth.signInWithCredential(
                  pendingCredential!,
                );
                final user = userCredential.user;

                if (user != null) {
                  await _firestoreService.saveUserData(
                    UserModel(
                      id: user.uid,
                      email: user.email ?? '',
                      name: user.displayName ?? '',
                      photoUrl: user.photoURL ?? '',
                    ),
                  );
                }
                return user;
              } on FirebaseAuthException {
                showProviderConflictDialog(context);
                return null;
              }
            } else {
              showProviderConflictDialog(context);
              return null;
            }
          } else {
            return null;
          }
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      GoogleSignIn().signOut(),
      FacebookAuth.instance.logOut(),
    ]);
  }

  User? get currentUser => _auth.currentUser;
}
