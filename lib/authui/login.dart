import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  //const LoginPage({Key key}) : super(key: key);

  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //var _formLoginKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.addListener(emailListener);
    passwordController.addListener(emailListener);
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void emailListener(){
    print('email');
  }

  //build two input fields inside a column
  Widget emailfield(){
    return TextField(
      controller: emailController,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'Email Address'
      ),
    );
  }  

  Widget passwordfield(){
    return TextField(
      controller: passwordController,
      obscureText: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: 'Password'
      ),
    );
  }  

  //build enter/continue button
  Widget continueButton(){
    return RaisedButton(
      onPressed: login,
      elevation: 10.0,
      child: new Text('Continue'),
      color: Colors.blue,
     
    );
  }

  //build button to navigate to signup page
  
  Widget signupButton(){
    return RaisedButton(
      onPressed: (){
        Navigator.of(context).pushReplacementNamed('/signup');
      },
      elevation: 10.0,
      child: new Text('Create new Account'),
      color: Colors.blue,
     
    );
  }

  //function to take care of continue button onpressed
  
  void login() async {
    final userPrefs = await SharedPreferences.getInstance();
    var email = userPrefs.getString('email');
    var password = userPrefs.getString('password');

    if (emailController.text.compareTo(email) == 0 || passwordController.text.compareTo(password) == 0){
      Navigator.of(context).pushReplacementNamed('/userboard');
    }else{
      print('error in sign in');
    }
  }

  
  
 
 //build column to hold all of the fields and button
 Widget fieldsColumn(){
   return Column(
      mainAxisAlignment: MainAxisAlignment.center,
     children: <Widget>[
       emailfield(),
       passwordfield(),
       continueButton(),
       signupButton()
     ],
   );
 }

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      body: new Center(
            child: new Padding(
            padding: EdgeInsets.all(20.0),
            child: fieldsColumn(),
          ),
          )
          
       
    );
  }
}