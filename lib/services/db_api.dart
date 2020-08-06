import 'package:burger_world/models/cart.dart';
import 'package:burger_world/models/food.dart';
import 'package:burger_world/models/toppings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseApi{

  Stream<List<Food>> getFoodList(String uid); 
  Future<void> addFoodToCart(Cart cart);
  void deleteFoodFromCart(Cart cart);
  void updateFoodWithToppings(Cart cart);
  


}