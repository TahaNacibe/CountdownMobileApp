import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  Future<User?> signInWithGoogle() async {
    // instances
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // sign in process
    try {
      // Trigger the Google sign-in flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Obtain the Google authentication
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  //* get current user
  User? getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  //* check if user is signed in
  bool isUserSignedIn() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser != null;
  }

  //* log out
  Future<void> signUserOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }
}
