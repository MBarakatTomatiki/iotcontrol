import 'package:mqtt_client/mqtt_client.dart';
import 'package:iotcontrol/mainui/userboard.dart';
import 'package:iotcontrol/utils/variables.dart';

class AppMqtt {
  MqttClient client = MqttClient('test.mosquitto.org', ''); //provide id
  double temperature = 1.0;

  final String sensorTopic = 'homeSensors';
  final String armTopic = 'arm';
  final String seLiteTopic = 'seclite';
  final String roLiteTopic = 'roomlite';

 

   void setTemperature(double tempe){
    this.temperature = tempe;
  }

  double getTemperature(){
    return this.temperature;
  }

   


  String previousTopic;
  bool bAlreadySubcribed = false;

  //subscribe
  Future<bool> subscribe(String topic) async {
    if (await _connectToClient() == true){
      client.onDisconnected = _onDisconnected;
      //add successful connection callback
      client.onConnected = _onConnected;

      //add a subscribed callback
      client.onSubscribed = _onSubscribed;
      _subscribe(topic);
    }
    return true;
  }

  //connect to broker
  Future<bool> _connectToClient() async{
    if(client != null && client.connectionStatus.state == MqttConnectionState.connected){
      print('already connected');
    }else{
      client = await _login();
      if(client == null) {
        return false;
      }
    }
    return true;
  }

  void _onSubscribed(String topic){
    print('Subscription confirmed for topic $topic');
    this.bAlreadySubcribed = true;
    this.previousTopic = topic;
  }

  void _onDisconnected(){
    print('OnDisconnected client callback - cliented disconnected');
    if(client.connectionStatus.returnCode == MqttConnectReturnCode.solicited){
      print(':OnDisconnected client is solicited, this is correct');
    }
    client.disconnect();
  }

  void _onConnected(){
    print('OnConnected client callback - Client connection was successful');
  }

  Future<MqttClient> _login() async {
    
    client.logging(on: true);
    final MqttConnectMessage connMess = MqttConnectMessage()
      //.authenticateAs('username', 'password')
      .withClientIdentifier('myClientID')
      .keepAliveFor(60)
      .withWillTopic('willTopic')
      .withWillMessage('my will message')
      .startClean()
      .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMess;

    try{
      await client.connect();
    } on Exception catch (e) {
      client.disconnect();
      client = null;
      return client;
    }

    //see if we are connected
    if(client.connectionStatus.state == MqttConnectionState.connected){
      print('client connected');
    }else{
      print('client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      client = null;
    }
    return client;
  }

  //publish
  Future<void> publish(String topic, String value){
    if(_connectToClient() == true){
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(value);
      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload);
    }
  }


  //subcribe
  Future _subscribe(String topic){
    
    if(this.bAlreadySubcribed == true){
      client.unsubscribe(this.previousTopic);
    }
    print('subscribing to the topic $topic');
    client.subscribe(topic, MqttQos.atMostOnce);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c){
      final MqttPublishMessage recMess = c[0].payload;
      final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message); //real message
      print('change Notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      if(c[0].topic.compareTo(sensorTopic) ==0){
        setTemperature(double.parse(pt));
      }
      return pt;
    });
  }


}