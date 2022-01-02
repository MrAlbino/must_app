import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:must/quote.dart';
import './mytodos.dart';
import './input_page.dart';



class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState()=> _HomePageState();
}

class _HomePageState extends State<HomePage>{

  final GlobalKey navKey = GlobalKey();
  var pagesAll = [const QuotePage(), const MyTodosPage(payload: '',), const InputPage()];

  var myIndex =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      bottomNavigationBar: CurvedNavigationBar(


        backgroundColor: Colors.transparent,

        key: navKey,
        items: [
          Icon((myIndex == 0) ? Icons.home : Icons.home_outlined),
          Icon((myIndex == 1) ? Icons.assignment_turned_in : Icons.assignment_turned_in_outlined),
          Icon((myIndex == 2) ? Icons.add_box : Icons.add_box_outlined),
        ],
        buttonBackgroundColor: Colors.white,
        onTap: (index){
          setState(() {

            if(index==3){
               //_showDialog(context);
              //_authService.signOut();
              //Navigator.pushReplacement(
                //  context,
                 // MaterialPageRoute(builder:(context)=> LoginPage()));

            }
            else{
              myIndex = index;
            }

          });
        },
        animationCurve: Curves.fastLinearToSlowEaseIn, color: Colors.orange,
      ),
      body: pagesAll[myIndex],
    );
  }
}
