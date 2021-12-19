import 'package:flutter/material.dart';
import 'package:must/home.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessPage extends StatefulWidget{
  const SuccessPage({Key? key}) : super(key: key);

  @override
  _SuccessPageState createState()=> _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage>{


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("MUST",
          style: GoogleFonts.pacifico(fontSize: 25,color:Colors.white),

        ),
        centerTitle: true,
      ),
      body:
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child:

                  Image.asset('images/tick.png'),
            ),

            Expanded(
              flex: 1,
              child:TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder:(context)=> HomePage()));
                },
                child: const Text('Anasayfa'),
                style: ButtonStyle(elevation: MaterialStateProperty.all(2), shape: MaterialStateProperty.all(const CircleBorder()), backgroundColor: MaterialStateProperty.all(Colors.orange), foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),

            ),
          ],
    ));
  }
}
