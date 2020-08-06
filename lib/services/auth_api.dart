abstract class AuthenticationApi{
  getFirebaseAuth();
  Future<String> currentUid();
  Future<void> signOut();
  Future<String> createUserWithEmailAndPassword({String email, String password});
  Future<String> signInWithEmailAndPassword({String email, String password});  
}