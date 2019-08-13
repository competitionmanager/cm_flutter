import 'package:cm_flutter/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) return null;

    GoogleSignInAuthentication googleSignInAuth =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuth.accessToken,
      idToken: googleSignInAuth.idToken,
    );

    FirebaseUser user = await auth
        .signInWithCredential(credential)
        .then((result) => result.user);
    return user;
  }

  void signOut() async {
    googleSignIn.signOut();
  }
}