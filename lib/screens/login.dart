import 'package:burger_world/blocs/login_bloc.dart';
import 'package:burger_world/resources/loading.dart';
import 'package:burger_world/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {

  Login({Key key}): super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String error = "";
  LoginBloc _loginBloc;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(Authentication());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _loginBloc.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return loading? Loading() :Scaffold(  
      backgroundColor: Colors.black54,  
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(top:80.0),
                child: Text(
                  "BurgerWorld".toUpperCase(),
                  style: GoogleFonts.shareTech(color: Colors.orange, fontSize: 50.0, fontWeight: FontWeight.bold,),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 8.0),
                child: Center(
                  child: Container(
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10.0),
                     color: Colors.orangeAccent
                   ),
                    height: 300,
                    child: Card(
                      color: Colors.orange[300],
                      elevation: 1.0,                
                      child:Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Form(
                          key: _formKey,
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  error,
                                  style: TextStyle(fontSize: 12, color: Colors.red),

                                ),
                              ),               


                              //email
                              StreamBuilder(
                                  stream: _loginBloc.email,
                                  builder: (BuildContext context, AsyncSnapshot snapshot) => TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: "Email Address",
                                    
                                      icon: Icon(Icons.mail_outline),
                                      errorText: snapshot.error
                                    ),
                                    onChanged: _loginBloc.emailChanged.add,
                                  )


                                  
                                  ),
                              
                        
                            //password
                            StreamBuilder(
                              stream: _loginBloc.password,
                              builder: (BuildContext context, AsyncSnapshot snapshot) => 
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    icon: Icon(Icons.security),
                                    errorText: snapshot.error
                                  ),
                                  onChanged: _loginBloc.passwordChange.add,
                                ),
                                


                            ),

                            SizedBox(
                              height: 48.0,
                            ),

                            _buildLoginAndCreateButton(),
                            

                          ],
                        ),

                        

                    ),
                      ),
      ),
                  ),
                ),
              ),
            ],
          ),
        )
      
    )
    );
  }

  Widget _buildLoginAndCreateButton(){
    //handle which set of button is active
    return StreamBuilder(
      initialData: "Login",
      stream: _loginBloc.loginOrCreateButton,
      builder: ((BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.data == "Login"){
          return _buttonsLogin();
        }else if(snapshot.data == "Create Account"){
          return _buttonsCreateAccount();
        }

      }),

    );
  }
  Widget _buttonsLogin(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            
            StreamBuilder(
              initialData: false,
              stream: _loginBloc.enableLoginCreateButton,
              builder: (BuildContext context, AsyncSnapshot snapshot) =>
                RaisedButton(
                  elevation: 16.0,
                  child: Text("Login"),
                  color: Colors.lightGreen.shade200,
                  disabledColor: Colors.grey.shade100,
                  

                  onPressed: () async{                    

                    if(snapshot.data){
                      setState(() {
                        loading = true;
                      });
                    
                    
                    _loginBloc.loginOrCreateChanged.add("Login");
                    if(await _loginBloc.authenticationApi.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text) == null ){
                      setState((){
                        error = "email/password incorrect";
                        loading = false;
                      });

                    }
                    }
                    
                  })
              
              ),
              FlatButton(
                child: Text("Create Account"),
                onPressed: (){
                  _loginBloc.loginOrCreateButtonChanged.add("Create Account");
                },

              ),

        
          ],
        ),
      ),
    );
  }

  Widget _buttonsCreateAccount(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamBuilder(
              initialData: false,
              stream:_loginBloc.enableLoginCreateButton,          
              builder: (BuildContext context, AsyncSnapshot snapshot) =>
                RaisedButton(
                  elevation: 16.0,
                  child: Text("Create Account"),
                  color:Colors.lightGreen.shade200,
                  disabledColor: Colors.grey.shade100,
                  
                  onPressed: snapshot.data
                ? () => _loginBloc.loginOrCreateChanged.add("Create Account")
                : null
                                    
                  
                )
            ),
            FlatButton(
              child:Text("Login"),
              onPressed: (){
                _loginBloc.loginOrCreateButtonChanged.add("Login");
              }
            )
            
            ],
        ),
      ),
    );
  }

  

}