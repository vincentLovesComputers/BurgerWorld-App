import 'dart:async';

import 'package:burger_world/services/auth_api.dart';
import 'package:burger_world/validator/validators.dart';


class LoginBloc with Validators{
  final AuthenticationApi authenticationApi;
  String _email;
  String _password;
  bool _emailValid;
  bool _passwordValid;

  /*email*/
  final StreamController<String> _emailController = StreamController<String>.broadcast();
  Sink<String> get emailChanged => _emailController.sink;
  //transform calls validators class stream transformer and validates email
  Stream<String> get email => _emailController.stream.transform(validateEmail);

  /*password*/
  final StreamController<String> _passwordController = StreamController<String>.broadcast();
  Sink<String> get passwordChange => _passwordController.sink;
  //call validators passwrod stream transformer to validate password
  Stream<String> get password => _passwordController.stream.transform(validatePassword);

  /*enable login button*/
  final StreamController<bool> _enableLoginCreateButtonController = StreamController<bool>.broadcast();
  Sink<bool> get enableLoginCreateButtonChanged => _enableLoginCreateButtonController.sink;
  Stream<bool> get enableLoginCreateButton => _enableLoginCreateButtonController.stream;

  /*loginOrCreate button*/
  final StreamController<String> _loginOrCreateButtonController = StreamController<String>();
  Sink get loginOrCreateButtonChanged => _loginOrCreateButtonController.sink;
  Stream get loginOrCreateButton => _loginOrCreateButtonController.stream;

  final StreamController<String> _loginOrCreateController = StreamController<String>();
  Sink get loginOrCreateChanged => _loginOrCreateController.sink;
  Stream get loginOrCreate => _loginOrCreateController.stream;
  LoginBloc(this.authenticationApi){
    _startListenersIfEmailAndPasswordAreValid();
  }

  void dispose(){
      _passwordController.close();
      _emailController.close();
      _enableLoginCreateButtonController.close();
      _loginOrCreateButtonController.close();
      _loginOrCreateController.close();
    }

  

  

   //login user with email.password cred
  Future<String> _logIn() async{
    String _result = "";   //checks if user login is success or not
    if(_emailValid && _passwordValid){
      await authenticationApi.signInWithEmailAndPassword(email: _email, password: _password).then((user){
        _result = "Success";
      }).catchError((error){
        print("Login error: $error");
        _result = error;
      });
      return _result;
    }else{
      return "Email and Password are not valid";
    }

  }

  //create user new account on success login user
  Future<String> _createAccount() async{
    String _result = "";
    if(_emailValid && _passwordValid){
      await authenticationApi.createUserWithEmailAndPassword(email: _email, password: _password).then((user){
        print("Created user: $user");
        _result = "Created user:  $user";
        authenticationApi.signInWithEmailAndPassword(email: _email, password: _password).then((user){
          }).catchError((error) async{
            print("Login error: $error");
            _result = error;
          });
        }).catchError((error) async{
          print("Creating user error: $error");
        });
        return _result;
      }else{
        return "Error creating user";
      }
    }

    //check whether _emailValid and _passwordVlaid  is true
    void _updateEnableLoginCreateButtonStream(){
      if(_emailValid ==true && _passwordValid ==true){
        enableLoginCreateButtonChanged.add(true);
      
    }else{
      enableLoginCreateButtonChanged.add(false);
    }

  }

  //set up listeners to check email, password and login or create button streams
  void _startListenersIfEmailAndPasswordAreValid(){

    //listen to email stream
    email.listen((email){
      _email = email;
      _emailValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error){
      _email ="";
      _emailValid = false;
      _updateEnableLoginCreateButtonStream();
    });

    //listen to password stream
    password.listen((password){
      _password = password;
      _passwordValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error){
      _password = "";
      _passwordValid = false;
      _updateEnableLoginCreateButtonStream();
    });

    //listen to loginOrCreate stream
    loginOrCreate.listen((action){
      action == "Login" ? _logIn() : _createAccount();
    });

    

    

 
  }

}

