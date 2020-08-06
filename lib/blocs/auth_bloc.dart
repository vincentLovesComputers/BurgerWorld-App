import 'dart:async';
import 'package:burger_world/services/auth_api.dart';

class AuthenticationBloc{
  final AuthenticationApi authApi;

  final StreamController<String> _authenticationController = StreamController<String>.broadcast();
  Sink<String> get addUser=> _authenticationController.sink;
  Stream<String> get user => _authenticationController.stream;


  final StreamController<bool> _logoutController = StreamController<bool>();
  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;

  AuthenticationBloc(this.authApi){
    onAuthChanged();
  }

  void dispose(){
    _authenticationController.close();
    _logoutController.close();
  }

  void onAuthChanged(){
    authApi.getFirebaseAuth().onAuthStateChanged.listen((user){
      final String uid = user != null ? user.uid: null;
      if(!_authenticationController.isClosed){
        addUser.add(uid);
      }
    });

    _logoutController.stream.listen((logout){
      if(logout == true){
        _signOut();
      }
    });
  }

  void _signOut(){
    authApi.signOut();
  }



}