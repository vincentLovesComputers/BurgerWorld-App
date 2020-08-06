import 'package:burger_world/blocs/auth_bloc.dart';
import 'package:burger_world/blocs/auth_bloc_provider.dart';
import 'package:burger_world/blocs/cart_bloc..dart';
import 'package:burger_world/blocs/homeBloc.dart';
import 'package:burger_world/blocs/homeBlocProvider.dart';

import 'package:burger_world/models/food.dart';
import 'package:burger_world/models/toppings.dart';
import 'package:burger_world/screens/cart.dart';
import 'package:burger_world/services/auth.dart';
import 'package:burger_world/services/db.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //set up UI
  Color backgroundColor = Colors.black87;


  final _scaffoldKey = new GlobalKey<ScaffoldState>();  
  HomeBloc _homeBloc;
  AuthenticationBloc _authenticationBloc;
  final CarouselController _controller = CarouselController();
  CartBloc _cartBloc = CartBloc(Database(), Authentication());

  var toppingsList = [];
  //toppings chosen by user stored in list
  List<String> chosenUserToppings = [];

  Toppings toppings;

  @override
  void initState() {    
    super.initState();
    toppings = Toppings();
    toppings.toppings.forEach((key, value) {
      toppingsList.add([key, value]);      
    });
  
    
    
        
    
  }

  @override
  void didChangeDependencies() { 
    super.didChangeDependencies();        
    _homeBloc = HomeBlocProvider.of(context).homeBloc; 
    _authenticationBloc = AuthenticationBlocProvider.of(context).authenticationBloc;
  }


  @override
  void dispose() {
    _homeBloc.dispose();
    _cartBloc?.dispose();
    _authenticationBloc.dispose();
    super.dispose();
  }


  void _showModalSheet({Food food}) {
      showModalBottomSheet(
      context: context,
      builder: (builder){
         return Container(
           height: MediaQuery.of(context).size.height *.33,
           color:Colors.orange,
           child: _buildModalBottomSheet(food: food));        
    });  
  }

  void _addToCart({Food food}){
    _cartBloc.saveFoodToCartChanged.add(food);
  }

  void chosenTopping({Food food, String topping}){
   

    chosenUserToppings.add(topping);
    _cartBloc.toppingschanged.add(chosenUserToppings);
    _cartBloc.saveFoodWithToppingToCartChanged.add(food);
    

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        //leading: IconButton(icon: Icon(Icons.menu), onPressed: (){}),
        
          
         title: Text(            
            "BURGERWORLD", 
            style: GoogleFonts.shareTech(color: Colors.orangeAccent[200], fontSize: 25, fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart), 
            onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(
                builder: (BuildContext context) =>
                  Cart()
                
                )
              ) ;                                   
                
            })
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children:<Widget>[
           Container(
             height:80,
             color: Colors.black,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Text("burgerworld".toUpperCase(),
                    style: GoogleFonts.shareTech(color: Colors.orangeAccent[200], fontSize: 30.0, fontWeight: FontWeight.bold,
                    )),

                 IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color:Colors.orange,
              ),
              onPressed: (){
                _authenticationBloc.logoutUser.add(true);
              },
            ) 
               ],
             )
             
           ),

           StreamBuilder<Object>(
             stream: _authenticationBloc.user,
             builder: (context, snapshot) {
               print(snapshot.data);
               return Container(
                 height: MediaQuery.of(context).size.height-80,
                 color: Colors.orangeAccent,                 


               );
             }
           )
  
            
          ]
        )
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
         child: Column(
            children: <Widget>[
              StreamBuilder(
                stream: _homeBloc.food,
                builder: (BuildContext context, AsyncSnapshot snapshot) { 
                  
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator());
                  }
                  else if(snapshot.hasData){
                    return Column(
                      children: <Widget>[
                        _buildHomePage(snapshot),
                         Container(
                           decoration: BoxDecoration(
                             color: Colors.orange[400],
                             borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0)
                           )
                             ),
                           child: _buildGridView(snapshot)),
                      ],

                    );
                    
                    
                  }                
                  else{
                    return Center(
                      child: Container(child:Text("connection lost"),)
                    );
                  }
                  
                 },
                
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildHomePage(AsyncSnapshot snapshot){

    List data = snapshot.data.toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: <Widget>[
        //backward button
        Padding(
          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 100.0),
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(10.0),
              color: Colors.orangeAccent,
            ),
            
            child: Center(
              child: IconButton(
                iconSize: 20,
                onPressed: ()=> _controller.nextPage(),
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
        ),


        //carousel
        _buildCarousel(data),

        //forward button
        Padding(
          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 100.0),
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(10.0),
              color: Colors.orangeAccent,
            ),
            
            child: Center(
              child: IconButton(
                iconSize: 20,
                onPressed: ()=> _controller.nextPage(),
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        ),
      
      ],
    );
  }

//carousel
  Widget _buildCarousel(List data) {    
    return Container(
      width: MediaQuery.of(context).size.width - 78,
      height: MediaQuery.of(context).size.height -190,
      child: CarouselSlider.builder(
        itemCount: data.length,  
        itemBuilder: (BuildContext context, int itemIndex) =>
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:10.0),
                child: Text(
                  "\$" + data[itemIndex].foodPrice, style: GoogleFonts.shareTech(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0,0.0,15.0 ),
                child: Text(
                  data[itemIndex].foodName.toUpperCase(), style:GoogleFonts.shareTech(color: Colors.orangeAccent[200], fontSize: 30.0, fontWeight: FontWeight.bold)

                ),
              ),

              
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width-200,
                  child: ClipRRect(
                    
                      borderRadius: BorderRadius.circular(25.0),
                      child: Image.network(                                                     
                      data[itemIndex].image == null ? "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSM0L9jJiPIbjdeXh2zrK4ikZqF0QYbHkLQkQ&usqp=CAU":
                      data[itemIndex].image,
                      fit: BoxFit.fill
                    ),
                  ),
              ),
                
              

              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  "OUR CLASSIC " + data[itemIndex].foodName.toUpperCase(), style: GoogleFonts.shareTech(color: Colors.orangeAccent[200], fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),

              Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 0.0),
                    child: SingleChildScrollView(
                      child: Container(
                        height: 50.0,
                        child: Text(
                          data[itemIndex].foodDescription, style: GoogleFonts.shareTech(letterSpacing: 2.0, color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  

                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 13.0, 0.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.grey[300])
                  ),
                  onPressed: (){                    
                    _showModalSheet(food: data[itemIndex]); },                       
                      
                    child:Text("ADD TOPPING", style: GoogleFonts.shareTech(fontWeight: FontWeight.bold, fontSize: 20.0, color:Colors.white,),),

                    )
              ),
              Padding(                    
                padding: const EdgeInsets.fromLTRB(13.0, 10.0, 0.0, 0.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.orange[600])
                  ),
                  color: Colors.orangeAccent[200],
                  child: Text("ORDER NOW", style: GoogleFonts.shareTech(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold,)),
                  onPressed: (){
                    
                    _addToCart(food: data[itemIndex] );

                  }),

              ),


                ],
              ),],
          ),  

        options: CarouselOptions(
          viewportFraction: 2.0,
          enlargeCenterPage: true,
          height: MediaQuery.of(context).size.height),

        carouselController: _controller,

      ),
      );
  }



  Widget _buildGridView(AsyncSnapshot snapshot){
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0,0.0, 20.0, 20.0),
      child: Container(
        child: GridView.builder(           

          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            ), 
          itemBuilder: (_, index) =>

            GridTile(
              child: Align(
                alignment: Alignment.center,
              child: Container(
                
                  width: 80,
                  height: 80,
                  child: new Card(
                    color: Colors.black87,
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      
                      borderRadius: BorderRadius.circular(50.0),
                      side: new BorderSide(color: Colors.orange, width: 3.0),
                    ),
                    
                    child: Image.network(
                      
                      snapshot.data[index].image != null?
                        snapshot.data[index].image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSM0L9jJiPIbjdeXh2zrK4ikZqF0QYbHkLQkQ&usqp=CAU",  
                        fit: BoxFit.scaleDown,               
                    ),
                    
                  ),
                ),
              ),
              
            )
          
          
          ),
      ),
    );
  }


  Widget _buildModalBottomSheet({Food food}){    
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 8.0, 40.0, 8.0),
        child: Column(
          children: <Widget>[       

            GridView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: toppingsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 3/2,
                crossAxisCount: 3,
                mainAxisSpacing: 0.1,
                crossAxisSpacing: 0.1,
              ), 
              itemBuilder: (_, index) =>          
                GridTile(                            
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            border: Border.all(
                              width:1,
                            ),
                          ),
                          child:InkWell(
                            onTap: () =>
                              
                            chosenTopping(food: food, topping: toppingsList[index][0]),
                            
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Image.asset(                            
                                  toppingsList[index][1] ,
                                  fit: BoxFit.fill,
                                  height: 35,
                                  width: 35,                                                     
                                  ),
                              ),
                          ),),                                    
                        Text(
                          toppingsList[index][0],
                          style:TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold)
                        )
                      ],
                    ),

                  )
                  
                  )      
              
              ),


          ],
        ),
      ),
    );
  }
 
}


