import 'package:decora/src/features/Auth/models/user_model.dart';
import 'package:decora/src/features/Auth/services/firestore_service.dart';
import 'package:decora/src/features/Auth/widgets/conflictDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirestoreService _firestoreService;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  AuthService({
    FirebaseAuth? firebaseAuth,
    FirestoreService? firestoreService,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookAuth,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance,
       _firestoreService = firestoreService ?? FirestoreService(),
       _googleSignIn = googleSignIn ?? GoogleSignIn(),
       _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  @visibleForTesting
  AuthService.testOnly({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FacebookAuth facebookAuth,
    FirestoreService? firestoreService,
  }) : _auth = firebaseAuth,
       _googleSignIn = googleSignIn,
       _facebookAuth = facebookAuth,
       _firestoreService = firestoreService ?? FirestoreService();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  FirestoreService get firestoreService => _firestoreService;
  User? get currentUser => _auth.currentUser;

  Future<User?> signUpWithEmail(
    String email,
    String password,
    String name,
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
          name: name,
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
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    if (googleAuth.accessToken == null && googleAuth.idToken == null) {
      return null;
    }
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
      final result = await _facebookAuth.login();

      if (result.status != LoginStatus.success) return null;

      final accessToken = result.accessToken!;
      final credential = FacebookAuthProvider.credential(
        accessToken.tokenString,
      );

      try {
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
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          final email = e.email;
          final pendingCredential = e.credential;

          if (email == null) return null;

          final methods = await _auth.fetchSignInMethodsForEmail(email);

          if (methods.contains('google.com')) {
            showProviderConflictDialog(context);
            return null;
          }

          if (methods.isEmpty && pendingCredential != null) {
            try {
              final userCredential = await _auth.signInWithCredential(
                pendingCredential,
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
        }
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {}

    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    try {
      await _facebookAuth.logOut();
    } catch (_) {}
  }
}
