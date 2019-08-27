import 'package:flutter/material.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:iotcontrol/utils/mqtt_utils.dart';
import 'package:iotcontrol/utils/variables.dart';
import 'package:iotcontrol/utils/thermometer_widget.dart';


class UserboardPage extends StatefulWidget {
  //const LoginPage({Key key}) : super(key: key);

  @override
  UserboardState createState() => new UserboardState();
}


/* final mqtt client = mqtt('test.mosquitto.org', '');

Future connect() async {
  client.logging(on: false);
  client.keepAlivePeriod = 30;

  final mqtt. 
}
 */
class UserboardState extends State<UserboardPage> {
  //var _formLoginKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final vpasswordController = TextEditingController();
  final deviceIDController = TextEditingController();

  final String sensorTopic = 'homeSensors';
  final String armTopic = 'arm';
  final String seLiteTopic = 'seclite';
  final String roLiteTopic = 'roomlite';

  Variables va;

  AppMqtt appMqtt = AppMqtt();


  

  @override
  void initState() {
    super.initState();
    emailController.addListener(emailListener);
    passwordController.addListener(emailListener);
    vpasswordController.addListener(vpasswordCon);
    deviceIDController.addListener(emailListener);

    //subscribe to topics
    subscribe(sensorTopic);
    subscribe(armTopic);
    subscribe(seLiteTopic);
    subscribe(roLiteTopic);

  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    vpasswordController.dispose();
    deviceIDController.dispose();
    super.dispose();
  }

 

  void subscribe(String topic){
    appMqtt.subscribe(topic);
  }

  void publish(String topic, String value){
    appMqtt.publish(topic, value);
  }

  void vpasswordCon(){
    if(passwordController.text.compareTo(vpasswordController.text) == 0){
      print('password does not match');
    }
    
     }

  void emailListener(){
    print('email');
  }


  Widget sizebox(){
    return SizedBox(
      child: ThermometerWidget(
        borderColor: Colors.amber,
        innerColor: Colors.yellow,
        indicatorColor: Colors.red,
        temperature: 28.0, // appMqtt.getTemperature(),
      )
    );
  }

  //build sliders buttons
  double seLite = 0.0;
  double roLite = 0.0;
  Widget sSlider(){
    return Slider(
      min: 0.0,
      max: 100.0,
      activeColor: Colors.green,
      inactiveColor: Colors.blue,
      divisions: 5,
      label: 'Security Light: $seLite',
      value: seLite,
      onChanged: (double newValue){  
        setState((){
          seLite = newValue;
        });
        publish(seLiteTopic, seLite.toString());
      },
      onChangeStart: (double newValue){
        
      },
      onChangeEnd: (double newValue){
          setState((){
          seLite = newValue;
        });
      },
    
    );
   
  }

  Widget roSlider(){
    return Slider(
      min: 0.0,
      max: 100.0,
      activeColor: Colors.green,
      inactiveColor: Colors.blue,
      divisions: 5,
      label: 'Room Light: $seLite',
      value: roLite,
      onChanged: (double newValue){  
        setState((){
          roLite = newValue;
        });
        publish(roLiteTopic, roLite.toString());
      },
      onChangeStart: (double newValue){
        
      },
      onChangeEnd: (double newValue){
          setState((){
          roLite = newValue;
        });
      },
    
    );
   
  }

  //build switc for arm
  bool isSwitch = false;
  Widget swArm(){
    return Switch(
      value: isSwitch,
      onChanged: (value){
        setState(() {
         isSwitch = value; 
        });

        if(isSwitch){
          publish(armTopic, 'arm');
        }else{
          publish(armTopic, 'unarm');
        }
      },
      activeColor: Colors.blue,
      activeTrackColor: Colors.red,
      
    );
  }

  
 

  //build enter/continue button
  Widget armButton(){
    return RaisedButton(
      //onPressed: signup,
      elevation: 10.0,
      child: new Text('Continue'),
      color: Colors.blue,
     
    );
  }
  

  Widget listTile(Widget lead, Widget trail){
    return ListTile(
      leading: lead,
      trailing: trail,
    );
  }

 
Widget screenPad(Widget c){
  return Padding(
    padding: EdgeInsets.all(0.5),
    child: c,
  );
}
  
  
 
 //build column to hold all of the fields and button
 Widget fieldsColumn(){
   return Column(
      mainAxisAlignment: MainAxisAlignment.center,
     children: <Widget>[
      // screenPad(sizebox()),       
       screenPad(sSlider()),
       screenPad(roSlider()),
       
       
     ],
   );
 }


 Widget videoView(){
   return new Container(
     width: 300,
     height: 200,
     color: Colors.yellow,
     
     

   );
 }

 dynamic retrDeviceID() async{
   final userPrefs = await SharedPreferences.getInstance();
   String deviceID =  userPrefs.get('deviceid').toString();
   return deviceID.toString();
 }

  @override
  Widget build(BuildContext context) {
       
    
    return new Scaffold(
      appBar: AppBar(
        
        title: Text('User Board'),
      ),
      body: new Column(
        children: <Widget>[
          new Container(
        alignment: AlignmentDirectional.topStart,
        color: Colors.yellow,
        width: 400,
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('humidity: 67%'),
            Text('ARMED: OFF'),
            Text('Device ID: IOT345')
          ],
        ), 
        ),

        new Container(
          color: Colors.black,
        width: 400,
        height: 150,
        child: Center(
          child: sizebox(),
        )
        ),

        fieldsColumn(),

        new Container(
          color: Colors.black,
        width: 400,
        height: 350,
        )
        ],
      )
      /* ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          videoView(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              sizebox(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  screenPad(listTile(new Text('ARM'), swArm())),
                  new Text('Humidity: ###', 
                    ) 
                ],
              )
            ],
          ),
          Container(
            alignment: AlignmentDirectional.bottomEnd,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/screen.png'),
            fit: BoxFit.cover
          )
        ),
        child: fieldsColumn(),
          ),
      

        ],
      ) */
       /* new Center(
            child: new Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/screen.png'),
            fit: BoxFit.cover
          )
        ),
        child: fieldsColumn(),
      )//fieldsColumn(),
          ),
          )  */
          
       
    );
  }
}