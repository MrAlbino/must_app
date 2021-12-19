import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import './success.dart';
import 'package:google_fonts/google_fonts.dart';
var uuid = const Uuid();

class InputPage extends StatefulWidget{
  const InputPage({Key? key}) : super(key: key);

  @override
  _InputPageState createState()=> _InputPageState();
}

class _InputPageState extends State<InputPage>{
  double _destinationDay=1;

  final _fs=  FirebaseFirestore.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController explanationController = TextEditingController();
  TextEditingController destinationDayController = TextEditingController();
    
  @override
  Widget build(BuildContext context) {
    //CollectionReference todosRef= _fs.collection('todos');
    //CollectionReference todosRef= _fs.collection('testCollection');
    CollectionReference todosRef= _fs.collection('todos');



    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title:  Text("MUST",
          style: GoogleFonts.pacifico(fontSize: 25,color:Colors.white),

        ),
        centerTitle: true,
      ),
      body: 
      Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: MyContainer(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const Text("Hedef Adı",style:TextStyle(
                      color:Colors.black54,fontSize: 20,fontWeight: FontWeight.bold
                  ),
                  ),
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: nameController,
                  ),
                ],
              )
              ),
            ),
             Expanded(
               flex: 2,
              child: MyContainer(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                   const Text("Hedef Açıklaması",style:TextStyle(
                      color:Colors.black54,fontSize: 20,fontWeight: FontWeight.bold
                  ),
                  ),
                  TextFormField(
                    style: const TextStyle(
                        color:Colors.black54,fontSize: 20,fontWeight: FontWeight.bold
                    ),
                    controller: explanationController,
                  ),
                ],
              )
              ),
            ),
             Expanded(
               flex: 2,
              child: MyContainer(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Hedef Gün",style:TextStyle(
                    color:Colors.black54,fontSize: 20,fontWeight: FontWeight.bold
                  ),
                  ),
                   Text(_destinationDay.round().toString(), style: const TextStyle(
                      color:Colors.lightBlue,fontSize: 25,fontWeight: FontWeight.bold
                  ),
                  ),
                  Slider(
                    thumbColor: Colors.orange,
                    max: 365,
                    min:1,
                    value: _destinationDay,
                    onChanged: (double value){
                      setState(() {
                        _destinationDay = value;

                      });
                    },
                  ),
                ],
              )
              ),
            ),
            
            Expanded(
              flex: 1,

                  child: TextButton(
                      onPressed: () async{
                        Map<String, dynamic> toDoData = {
                        'name': nameController.text,
                        'explanation': explanationController.text,
                        'deadline': DateTime.now().add(Duration(days:_destinationDay.toInt())),
                        };
                        await todosRef.doc(uuid.v4()).set(toDoData);

                        todosRef.add({'test':55});
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder:(context)=> SuccessPage()));
                      },
                      child: const Text('Oluştur'),
                      style: ButtonStyle(elevation: MaterialStateProperty.all(2), shape: MaterialStateProperty.all(const CircleBorder()), backgroundColor: MaterialStateProperty.all(Colors.orange), foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  ),

            ),
          ],
        ),
      ),
    );
  }
}

class MyContainer extends StatelessWidget {

  final Color colorUser;
  final Widget child;
  const MyContainer({this.colorUser=Colors.white,required this.child,Key? key}) : super(key: key) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)
        ,color: colorUser,
      ),
    );
  }
}
