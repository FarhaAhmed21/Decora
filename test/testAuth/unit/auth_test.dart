import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:decora/src/features/Auth/services/auth_service.dart';
import '../../mocks.dart';
import '../../mocks.mocks.dart';

void main() {
  late AuthService authService;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;
  late MockUserCredential mockCredential;
  late MockGoogleSignIn mockGoogle;
  late MockFacebookAuth mockFb;
  late MockFirestoreService mockFirestore;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockCredential = MockUserCredential();
    mockFirestore = MockFirestoreService();

    when(mockCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('123');
    when(mockUser.email).thenReturn('test@example.com');
    when(mockUser.displayName).thenReturn('John Doe');
    when(mockUser.photoURL).thenReturn('https://photo.url');

    mockGoogle = MockGoogleSignIn();
    mockFb = MockFacebookAuth();

    authService = AuthService.testOnly(
      firebaseAuth: mockAuth,
      googleSignIn: mockGoogle,
      facebookAuth: mockFb,
      firestoreService: mockFirestore,
    );
  });

  group('Email', () {
    test('sign up returns user', () async {
      when(
        mockAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: '123456',
        ),
      ).thenAnswer((_) async => mockCredential);

      final user = await authService.signUpWithEmail(
        'test@example.com',
        '123456',
        'John Doe',
      );

      expect(user, mockUser);
    });

    test('sign in returns user', () async {
      when(
        mockAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: '123456',
        ),
      ).thenAnswer((_) async => mockCredential);

      final user = await authService.signInWithEmail(
        'test@example.com',
        '123456',
      );

      expect(user, mockUser);
    });
  });

  group('Google', () {
    test('sign in calls Google sign in', () async {
      when(mockGoogle.signIn()).thenAnswer((_) async => null);

      final user = await authService.signInWithGoogle();

      expect(user, isNull);
      verify(mockGoogle.signIn()).called(1);
    });
  });

  group('Facebook', () {
    test('sign in calls Facebook login', () async {
      final mockLoginResult = MockLoginResult();
      when(mockLoginResult.status).thenReturn(LoginStatus.cancelled);
      when(mockFb.login()).thenAnswer((_) async => mockLoginResult);

      final user = await authService.signInWithFacebook(MockBuildContext());

      expect(user, isNull);
      verify(mockFb.login()).called(1);
    });
  });

  group('Sign out', () {
    test('calls signOut on all providers', () async {
      when(mockAuth.signOut()).thenAnswer((_) async => {});
      when(mockGoogle.signOut()).thenAnswer((_) async => null);
      when(mockFb.logOut()).thenAnswer((_) async => {});

      await authService.signOut();

      verify(mockAuth.signOut()).called(1);
      verify(mockGoogle.signOut()).called(1);
      verify(mockFb.logOut()).called(1);
    });
  });
}
