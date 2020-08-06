import 'package:burger_world/blocs/auth_bloc.dart';
import 'package:burger_world/blocs/auth_bloc_provider.dart';
import 'package:burger_world/blocs/homeBloc.dart';
import 'package:burger_world/blocs/homeBlocProvider.dart';
import 'package:burger_world/screens/home.dart';
import 'package:burger_world/screens/login.dart';
import 'package:burger_world/services/auth.dart';
import 'package:burger_world/services/db.dart';
import 'package:burger_world/services/db_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final Authentication _authenticationService = Authentication();
    final AuthenticationBloc _authenticationBloc = AuthenticationBloc(_authenticationService);


    return AuthenticationBlocProvider(
      authenticationBloc: _authenticationBloc,
      child:StreamBuilder(
        stream: _authenticationBloc.user,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Container(
              color: Colors.lightGreen,
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasData){
            return HomeBlocProvider(
             homeBloc: HomeBloc(Database(), _authenticationService),
             uid: snapshot.data,
             child: _buildMaterialApp(Home()),);      
          }else{
           
            return _buildMaterialApp(Login());
          }


        })

    );
  }

  MaterialApp _buildMaterialApp(Widget homePage){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Security',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
      ),


      home: homePage,
    );
  }

  
}
