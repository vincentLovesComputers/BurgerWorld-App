
class Food{
  String documentID;
  String foodName;
  String foodPrice;
  String foodDescription;
  String image;
  List ingredients;
  List topping;

  Food({this.documentID, this.foodName, this.foodPrice, this.foodDescription, this.ingredients, this.image, this.topping});

  factory Food.fromDoc(dynamic doc) => Food(
    documentID: doc.documentID,
    foodName: doc["foodName"],
    foodPrice: doc["foodPrice"],
    foodDescription: doc["foodDescription"],
    ingredients: doc["ingredients"],
    image: doc["image"],
    topping: doc["topping"]

  );


}