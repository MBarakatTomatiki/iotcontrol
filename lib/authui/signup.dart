import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  //const LoginPage({Key key}) : super(key: key);

  @override
  SignupState createState() => new SignupState();
}

class SignupState extends State<SignupPage> {
  //var _formLoginKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final vpasswordController = TextEditingController();
  final deviceIDController = TextEditingController();

  

  @override
  void initState() {
    super.initState();
    emailController.addListener(emailListener);
    passwordController.addListener(emailListener);
    vpasswordController.addListener(vpasswordCon);
    deviceIDController.addListener(emailListener);
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    vpasswordController.dispose();
    deviceIDController.dispose();
    super.dispose();
  }

  void vpasswordCon(){
    if(passwordController.text.compareTo(vpasswordController.text) == 0){
      print('password does not match');
    }
    
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

Widget deviceIDfield(){
    return TextField(
      controller: deviceIDController,
      obscureText: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'Device ID'
      ),
    );
  }

  Widget passwordfield(){
    return TextField(
      controller: passwordController,
      obscureText: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'Password'
      ),
    );
  } 

  Widget vpasswordfield(){
    return TextField(
      controller: vpasswordController,
      obscureText: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: 'Verify Password'
      ),
    );
  }  

  //build enter/continue button
  Widget continueButton(){
    return RaisedButton(
      onPressed: signup,
      elevation: 10.0,
      child: new Text('Continue'),
      color: Colors.blue,
     
    );
  }

  Widget loginButton(){
    return RaisedButton(
      onPressed: (){
         Navigator.of(context).pushReplacementNamed('/login');
      },
      elevation: 10.0,
      child: new Text('Login'),
      color: Colors.blue,
     
    );
  }

  //function to take care of continue button onpressed
  void  signup() async{
    final userPrefs = await SharedPreferences.getInstance();
    userPrefs.setString('email', emailController.text);
    userPrefs.setString('password', passwordController.text);
    userPrefs.setString('deviceid', deviceIDController.text);

    Navigator.of(context).pushReplacementNamed('/userboard');

  }

  bool _isLoading = false;

  Widget _showCircularProgress(){
  if (_isLoading) {
    return Center(child: CircularProgressIndicator());
  } return Container(height: 0.0, width: 0.0,);

}

  
  
 
 //build column to hold all of the fields and button
 Widget fieldsColumn(){
   return Column(
      mainAxisAlignment: MainAxisAlignment.center,
     children: <Widget>[
       deviceIDfield(),
       emailfield(),
       passwordfield(),
       vpasswordfield(),
       continueButton(),
       loginButton()
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