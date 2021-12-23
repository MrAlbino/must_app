import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;


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

  final _random = Random();


  Future<void> getQuote() async {
    String baseUrl = 'https://api.quotable.io/random';

    try {
      http.Response response = await http.get(Uri.parse(baseUrl));
      var myQuote = Quote.fromJson(jsonDecode(response.body));
      setState(() {
        _quote = myQuote.quote;
      });
    } catch (e) {}
  }

  void _getNewQuote() {
    setState(() {
      _quote = '';
    });
    getQuote();
  }

  @override
  void initState() {
    super.initState();
    getQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24.0),

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
}

