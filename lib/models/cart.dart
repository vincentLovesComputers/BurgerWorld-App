class Cart{
  
  String foodName;
  String foodPrice;
  String documentID;
  String uid;
  List toppings;
  String image;

  Cart({this.documentID, this.foodName, this.foodPrice, this.uid, this.toppings, this.image});

  factory Cart.fromDoc(dynamic doc) => Cart(
    documentID: doc["documentID"],
    foodPrice: doc["foodPrice"],
    foodName: doc["foodName"],
    uid: doc["uid"],
    toppings: doc["toppings"],
    image: doc["image"]
  );
}
