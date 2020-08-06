import 'package:burger_world/blocs/homeBloc.dart';
import 'package:flutter/cupertino.dart';

class HomeBlocProvider extends InheritedWidget{

  final HomeBloc homeBloc;
  final String uid;
  const HomeBlocProvider({Key key, Widget child, this.homeBloc, this.uid}) : super(key:key, child:child);

  static HomeBlocProvider of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(HomeBlocProvider) as HomeBlocProvider);
  }

  @override
  bool updateShouldNotify(HomeBlocProvider old) =>
    homeBloc != old.homeBloc;
  

}