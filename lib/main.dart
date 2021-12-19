import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './input_page.dart';
import './mytodos.dart';
import './success.dart';
import 'package:firebase_core/firebase_core.dart';





void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MustApp());

}


class MustApp extends StatelessWidget {
  const MustApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.yellow,
        scaffoldBackgroundColor: const Color.fromRGBO(231, 220, 217, 1.0),
      ),
          home: const MyTodosPage(),
    );
  }
}

