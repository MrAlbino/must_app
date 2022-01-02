import 'package:flutter/material.dart';
import 'package:must/login.dart';

import 'package:firebase_core/firebase_core.dart';

import 'api/notification_api.dart';
import 'mytodos.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MustApp());

}
class MustApp extends StatefulWidget {
  const MustApp({Key? key}) : super(key: key);

  @override
  _MustAppState createState() => _MustAppState();
}
class _MustAppState extends State<MustApp> {
  @override
  void initState(){
    super.initState();
    NotificationApi.init(initScheduled: true);
    listenNotifications();
  }
  void listenNotifications()=>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload)=>
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyTodosPage(payload:payload)));

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.yellow,
        scaffoldBackgroundColor: const Color.fromRGBO(231, 220, 217, 1.0),
      ),
          home: LoginPage(),
    );
  }

}