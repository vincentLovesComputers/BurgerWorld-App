import 'package:burger_world/blocs/auth_bloc.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationBlocProvider extends InheritedWidget{
  @override

  final AuthenticationBloc authenticationBloc;

  const AuthenticationBlocProvider({Key key, Widget child, this.authenticationBloc}): super(key:key, child:child);

  static AuthenticationBlocProvider of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(AuthenticationBlocProvider) as AuthenticationBlocProvider);
  }

  
  bool updateShouldNotify(AuthenticationBlocProvider old) {
    authenticationBloc != old.authenticationBloc;
  }



}