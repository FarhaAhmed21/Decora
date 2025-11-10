import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  QuerySnapshot,
  QueryDocumentSnapshot,
])
void main() {}
