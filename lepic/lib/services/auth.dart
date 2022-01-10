import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase{
  User? get currentUser;
  //Future<User?> getCurrentUser();
  Stream<User?> authStateChanges();
  Future<User?> signInWithEmail({required String email, required String password});
  Future<User?> signUpWithEmail({required String email, required String password});
  Future<User?> signInWithGoogle();
  Future<void> logOut();
  Future<String?> getCurrentUserEmail();

}
class Auth implements AuthBase{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /*
  @override
  Future<User?> getCurrentUser() async {
    return await _auth.currentUser;
  }

   */
  @override
  User? get currentUser => _auth.currentUser;
  @override
  Future<String?> getCurrentUserEmail() async {
    String a = await _auth.currentUser!.email.toString();
    print(a);
    return a;
  }
  @override
  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _auth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User?> signInWithEmail({required String email, required String password}) async {
  final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
  return userCredential.user;
  }
  @override
  Future<void> logOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<User?> signUpWithEmail({required String email, required String password}) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

}