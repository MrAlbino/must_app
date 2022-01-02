import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './login.dart';
import 'package:must/custom_dialog.dart';
import 'package:must/service/auth.dart';
// ignore_for_file: prefer_const_constructors

class Quote {
  final String quote;

  Quote.fromJson(Map<String, dynamic> json)
      : quote = json['content'];
}

class QuotePage extends StatefulWidget{
  const QuotePage({Key? key}) : super(key: key);

  @override
  _QuotePageState createState()=> _QuotePageState();
}

class _QuotePageState extends State<QuotePage>{
  String _quote='';
  final AuthService _authService = AuthService();



  Future<void> getQuote() async {
    String baseUrl = 'https://api.quotable.io/random';

    try {
      http.Response response = await http.get(Uri.parse(baseUrl));
      var myQuote = Quote.fromJson(jsonDecode(response.body));
      setState(() {
        _quote = myQuote.quote;
      });
    } catch (e) {
      setState(() {
        _quote="While there is hope, there is life.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("MUST",
          style: GoogleFonts.pacifico(fontSize: 25,color:Colors.white),

        ),
        centerTitle: true,
        actions: <Widget>[
          // First button - decrement
          IconButton(
              icon: const Icon(Icons.logout_outlined), // The "-" icon
              onPressed:() {
                _showDialog(context);
              } // The `_decrementCounter` function
          ),

          // Second button - increment
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:AssetImage('images/greenleaf.jpg'),
            fit: BoxFit.cover,
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Stack(
                  children: const <Widget>[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 24.0),

                      ),
                    ),

                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: _quote != null
                        ? Text('$_quote',
                      style: GoogleFonts.indieFlower(fontSize: 35,color:Colors.black),)
                        : CircularProgressIndicator(),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context){

    BlurryDialog  alert = BlurryDialog("Are you sure you want to exit?",(){
      Navigator.of(context).pop();
      _authService.signOut();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder:(context)=> LoginPage()));
    });


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

