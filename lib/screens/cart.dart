import 'package:burger_world/blocs/cart_bloc..dart';
import 'package:burger_world/services/auth.dart';
import 'package:burger_world/services/db.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();  
}

class _CartState extends State<Cart> {

  CartBloc cartBloc = CartBloc(Database(),Authentication() );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  void dispose() {
    super.dispose();
    cartBloc.dispose();
  }

  Future<bool> _confirmDeleteCartItem() async{
    return await showDialog(
      context: context,
      barrierDismissible: false,

      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Delete from Cart"),
          content: Text("Are you sure you would like to delete item?"),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context, false);

              }, 
              child: Text("cancel".toUpperCase())),

              FlatButton(
              onPressed: (){                
                Navigator.pop(context, true);

              }, 
              child: Text("delete".toUpperCase(), style: TextStyle(color:Colors.red),)),

            
          ],

        );
      }
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black87,
        //leading: IconButton(icon: Icon(Icons.menu), onPressed: (){}),
        title: Text("BURGERWORLD", style: GoogleFonts.shareTech(color: Colors.orangeAccent, fontSize: 25, fontWeight: FontWeight.bold),),
        centerTitle: true,
        
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[            

            StreamBuilder(
              stream: cartBloc.cart,              
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );                  
                }

                else if(snapshot.hasData){
                  return _buildCartListView(snapshot);
                }
                else{
                  return Center(
                    child: Text("Cart items"),
                  );
                }
              },
            ),



          ],
        ),
      ),
    );
  }

  Widget _buildCartListView(AsyncSnapshot snapshot){
    
    return 
          Column(
        children: <Widget>[
          Container(
            height: 100.0,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight:Radius.circular(25.0)),
            ),
            child: Center(child: Text("Cart", style: TextStyle(color: Colors.orangeAccent, fontSize: 20.0, fontWeight: FontWeight.bold),)),
          ),
          ListView.builder(
            physics: ScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){

                String foodName = snapshot.data[index].foodName;
                String foodPrice = snapshot.data[index].foodPrice;

                return Dismissible(
                  key: Key(snapshot.data[index].documentID), 


                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left:16.0),
                    child: Icon(
                      Icons.delete,
                      color:Colors.white,
                    ),
                  ),

                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(left:16.0),
                    child: Icon(
                      Icons.delete,
                      color:Colors.white,
                    ),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                    child: Container(
                      height: 100.0,
                      child: Card(
                        color: Colors.orangeAccent[200],
                        elevation: 1.0,
                        child: ListTile(
                          title: Text(foodName, style: TextStyle(fontSize: 20.0, color: Colors.black),),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("\$$foodPrice", style: TextStyle(fontSize: 15.0, color: Colors.black),),
                              Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Text("Toppings: ${snapshot.data[index].toppings}", style: TextStyle(fontSize: 15.0, color: Colors.black),),
                              ),
                            ],
                          ),
                          trailing: Container(
                            height: 150.0,
                            width: 120.0,
                            child: Image.network(
                                snapshot.data[index].image != null?
                                  snapshot.data[index].image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSM0L9jJiPIbjdeXh2zrK4ikZqF0QYbHkLQkQ&usqp=CAU",  
                                  fit: BoxFit.fill,  
                            ),
                          ),             
                            
                          
                        ),
                      ),
                    ),
                  ),

                  confirmDismiss: (direction) async{
                    bool confirmDelete = await _confirmDeleteCartItem();
                    if(confirmDelete){
                      cartBloc.deleteCart.add(snapshot.data[index]);
                      print("deleted");
                      
                    }

                  },
                
                  
                  
                  );

              },
              
              ),
          
        ],
     
    );
  }


}