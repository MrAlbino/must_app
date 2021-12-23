import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import './mytodos.dart';
import './input_page.dart';
import 'package:must/service/auth.dart';
import './login.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState()=> _HomePageState();
}

class _HomePageState extends State<HomePage>{

  GlobalKey _NavKey = GlobalKey();
  AuthService _authService = AuthService();
  var PagesAll = [MyTodosPage(),InputPage(),HomePage()];

  var myindex =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CurvedNavigationBar(


        backgroundColor: Colors.transparent,

        key: _NavKey,
        items: [
          Icon((myindex == 0) ? Icons.assignment_turned_in : Icons.assignment_turned_in_outlined),
          Icon((myindex == 1) ? Icons.add_box : Icons.add_box_outlined),
          Icon((myindex == 2) ? Icons.home : Icons.home_outlined),
          Icon((myindex == 3) ? Icons.logout : Icons.logout_outlined),
        ],
        buttonBackgroundColor: Colors.white,
        onTap: (index){
          setState(() {

            if(index==3){
              _authService.signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder:(context)=> LoginPage()));
            }
            else{
              myindex = index;
            }

          });
        },
        animationCurve: Curves.fastLinearToSlowEaseIn, color: Colors.orange,
      ),
      body: PagesAll[myindex],
    );
  }
}
