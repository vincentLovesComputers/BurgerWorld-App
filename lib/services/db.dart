import 'package:burger_world/models/cart.dart';
import 'package:burger_world/models/food.dart';
import 'package:burger_world/services/db_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database implements DatabaseApi{
  Firestore _firestore = Firestore.instance;
  String _collection = "burgerStore";
  CollectionReference burgerStoreReference = Firestore.instance.collection("burgerStore"); 


  @override
  Stream<List<Food>> getFoodList(String uid) {
    return _firestore
            .collection(_collection)
              .snapshots().map((QuerySnapshot snapshot){
                List<Food> _getDoc = snapshot.documents.map((data) => Food.fromDoc(data)).toList();  
                return _getDoc;             
              });              
  }

  @override
  Stream<List<Cart>> getCartList(String uid) {
    return _firestore
            .collection("cart")
              .where("uid", isEqualTo: uid)
              .snapshots()
                .map((QuerySnapshot snapshot){
                  List<Cart> _getCartDoc = snapshot.documents.map((data) => Cart.fromDoc(data)).toList();
                  return _getCartDoc;
                });
  }

  @override
  void updateFoodWithToppings(Cart cart) async{
    print("updating cart");
    await _firestore.collection("cart").document(cart.documentID).updateData({
      "documentID": cart.documentID,      
      "foodName": cart.foodName,
      "foodPrice": cart.foodPrice,
      "toppings": cart.toppings,
      "image": cart.image,
            
    });
    
  }

  @override
  Future<void> addFoodToCart(Cart cart) async{      
      await _firestore.collection("cart")
              .document(cart.documentID).setData({
                "foodName": cart.foodName,
                "foodPrice":cart.foodPrice,
                "documentID": cart.documentID,
                "uid": cart.uid ,
                "toppings": cart.toppings,
                "image": cart.image,

              });          

    }
  
    @override
    void deleteFoodFromCart(Cart cart) async{
      await _firestore.collection("cart")
        .document(cart.documentID)
          .delete()
            .catchError((error) => print(error));
      
  }



  
  

  


  


}