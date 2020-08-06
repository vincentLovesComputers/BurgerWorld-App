import 'package:burger_world/blocs/cart_bloc..dart';
import 'package:flutter/cupertino.dart';

class CartBlocProvider extends InheritedWidget{

  final CartBloc cartBloc;


  const CartBlocProvider({Key key, Widget child, this.cartBloc}) : super(key:key, child:child);

  static CartBlocProvider of(BuildContext context){
    return(context.inheritFromWidgetOfExactType(CartBlocProvider) as CartBlocProvider);
  }



  @override
  bool updateShouldNotify(CartBlocProvider old) => false;
   
    
  

}