import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/src/features/Auth/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

/// Combine all mocks here so mockito generates a single `.mocks.dart` file
@GenerateMocks([
  // Firebase Auth & related classes
  FirebaseAuth,
  User,
  UserCredential,

  // Google Sign-In
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,

  // Facebook Auth
  FacebookAuth,
  LoginResult,
  AccessToken,

  // Firestore
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  QuerySnapshot,
  QueryDocumentSnapshot,

  // Custom service
  FirestoreService,
])
class MockBuildContext extends Mock implements BuildContext {}

void main() {}
