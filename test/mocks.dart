
import 'package:decora/src/features/Auth/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  FirebaseAuth,
  User,
  UserCredential,
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  FacebookAuth,
  LoginResult,
  AccessToken,
  FirestoreService,
])
class MockBuildContext extends Mock implements BuildContext {}

import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@GenerateMocks([FirebaseFirestore, CollectionReference, DocumentReference])
void main() {}
