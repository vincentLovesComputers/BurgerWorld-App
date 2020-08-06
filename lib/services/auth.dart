import 'package:burger_world/services/auth_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication implements AuthenticationApi{
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  

  @override
    getFirebaseAuth() {
      return _firebaseAuth;
    }


  @override
  Future<String> currentUid() async{
    try{
      FirebaseUser user = await _firebaseAuth.currentUser();
      return user.uid;
    }
    catch(error){
      print(error.toString());
      return null;
    }
                  
    }


  @override
  Future<String> createUserWithEmailAndPassword({String email, String password}) async {
     try{
       FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim())).user;
       return user.uid;      
     }catch(error){
       print(error.toString());
       return null;
     }
    }
    
  
    @override
    Future<String> signInWithEmailAndPassword({String email, String password}) async{
    try{
      FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password.trim())).user;
      return user.uid;      

    }catch(error){
      print(error.toString());
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try{
      return await _firebaseAuth.signOut();
    }catch(error){
      print(error.toString());
      return null;
    }
  }

}