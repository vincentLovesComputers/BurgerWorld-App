import 'dart:async';

import 'package:burger_world/models/food.dart';
import 'package:burger_world/services/auth_api.dart';
import 'package:burger_world/services/db_api.dart';

class HomeBloc{

  final DatabaseApi dbApi;
  final AuthenticationApi authApi;

  final StreamController<List<Food>> _foodController = StreamController<List<Food>>.broadcast();
  Sink<List<Food>> get addFood => _foodController.sink;
  Stream<List<Food>> get food => _foodController.stream;


  HomeBloc(this.dbApi, this.authApi){
    _startListeners();
  }

  void dispose(){
    _foodController.close();
        
  }

  void _startListeners(){
    authApi.getFirebaseAuth().currentUser().then((user){
      dbApi.getFoodList(user.uid).listen((doc) {
      if(!_foodController.isClosed)  {
        addFood.add(doc);
      }    
    });
    });
  }

  }