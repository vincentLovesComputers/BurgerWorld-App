import 'dart:async';

import 'package:burger_world/models/cart.dart';
import 'package:burger_world/models/food.dart';
import 'package:burger_world/services/auth_api.dart';
import 'package:burger_world/services/db.dart';

class CartBloc{

  final Database dbApi;
  final AuthenticationApi authenticationApi;
  List listOfCartItems = [];


  StreamController<List<Cart>> _cartController = StreamController<List<Cart>>.broadcast();
  Sink<List<Cart>> get cartChanged => _cartController.sink;
  Stream<List<Cart>> get cart => _cartController.stream;

  StreamController<List<String>> _toppingsController = StreamController<List<String>>.broadcast();
  Sink<List<String>> get toppingschanged => _toppingsController.sink;
  Stream<List<String>> get toppings => _toppingsController.stream;

  final StreamController<Cart> _cartDeleteController = StreamController<Cart>.broadcast();
  Sink<Cart> get deleteCart => _cartDeleteController.sink;

  final StreamController<Food> _saveFoodToCartController = StreamController<Food>.broadcast();
  Sink<Food> get saveFoodToCartChanged => _saveFoodToCartController.sink;
  Stream<Food> get saveFoodToCart => _saveFoodToCartController.stream;

  final StreamController<Food> _saveFoodWithToppingToCartController = StreamController<Food>.broadcast();
  Sink<Food> get saveFoodWithToppingToCartChanged => _saveFoodWithToppingToCartController.sink;
  Stream<Food> get saveFoodWithToppingToCart => _saveFoodWithToppingToCartController.stream;




  CartBloc(this.dbApi, this.authenticationApi){
    _startListeners();          
  }

  void dispose(){
     _cartController.close();
     _cartDeleteController.close();
     _toppingsController.close();
    _saveFoodToCartController.close();
    _saveFoodWithToppingToCartController.close();
  }


  void _startListeners() async {
    
    //get currently authenticated user
    authenticationApi.getFirebaseAuth().currentUser().then((user){
      dbApi.getCartList(user.uid).listen((cartDocs) {
        if(!_cartController.isClosed){
          cartChanged.add(cartDocs);  

        }                      
        else{
          print("controller is closed");
        }    
      });

      //add food to cart without topping
      _saveFoodToCartController.stream.listen((food){
       Cart cart = Cart(
         documentID: food.documentID,
         foodName: food.foodName,
         foodPrice: food.foodPrice,         
         uid: user.uid,
         image: food.image         
          );
          
      dbApi.addFoodToCart(cart);
    });

    //add to cart new food with topping
    _toppingsController.stream.listen((toppings) {
      _saveFoodWithToppingToCartController.stream.listen((foodWithTopping) {
        Cart newCart = Cart(
          documentID: foodWithTopping.documentID,
          foodName: foodWithTopping.foodName,
          foodPrice: foodWithTopping.foodPrice,
          uid: user.uid,
          toppings: toppings,
          image: foodWithTopping.image
        );


        dbApi.addFoodToCart(newCart);
      });
            
    });
    

    //delete from
    _cartDeleteController.stream.listen((cart) {
      dbApi.deleteFoodFromCart(cart);      
    });


    });
    

    


    
  }



  

}