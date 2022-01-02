import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './login.dart';
import 'package:must/custom_dialog.dart';
import 'package:intl/intl.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;


class MyTodosPage extends StatefulWidget{
  final String? payload;
  const MyTodosPage({Key? key,required this.payload}) : super(key: key);

  @override
  _MyTodosPageState createState()=> _MyTodosPageState();
}


class _MyTodosPageState extends State<MyTodosPage>{
  final _fs=  FirebaseFirestore.instance;

  Color getMyColor(DateTime date, bool done) {
    if (done) {
      return Colors.green;
    } else if(DateTime.now().isBefore(date)){
      return Colors.orange.shade200;
    }
    else{
      return Colors.red.shade500;
    }

  }


  @override
  Widget build(BuildContext context) {
    CollectionReference todosRef= _fs.collection('todos');
    CollectionReference _usersRef= _fs.collection('Users');
    final User? user =_auth.currentUser;
    final userId = user!.uid;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body:Center(
        child: Container(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                /// Neyi dinlediğimiz bilgisi, hangi streami
                stream: todosRef.where('user' ,isEqualTo: userId).snapshots(),
                /// Streamden her yerni veri aktığında, aşağıdaki metodu çalıştır
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return const Center(
                        child: Text('Bir Hata Oluştu, Tekrar Deneyiniz'));
                  } else {
                    if (asyncSnapshot.hasData) {
                      List<DocumentSnapshot> listOfDocumentSnap =
                          asyncSnapshot.data.docs;
                      return Flexible(
                        child: ListView.builder(
                          itemCount: listOfDocumentSnap.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color:getMyColor(DateTime.parse((listOfDocumentSnap[index]['deadline']).toDate().toString()),listOfDocumentSnap[index]['done']) ,

                              child: ListTile(
                                title: Text(
                                    '${listOfDocumentSnap[index]['name']}',
                                    style: const TextStyle(fontSize: 24)),
                                subtitle: Text(
                                    'Son Tarih: '+DateFormat('yyyy-MM-dd kk:mm').format(DateTime.parse((listOfDocumentSnap[index]['deadline']).toDate().toString())),
                                    style: const TextStyle(fontSize: 16)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [  if(listOfDocumentSnap[index]['done'])...[
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        var todoId= listOfDocumentSnap[index].id;
                                        await listOfDocumentSnap[index]
                                            .reference
                                            .delete();
                                        _usersRef.doc(userId).update({'todo_list':FieldValue.arrayRemove([todoId])});
                                      },
                                    ),
                                  ]
                                    else if(DateTime.now().isBefore(DateTime.parse((listOfDocumentSnap[index]['deadline']).toDate().toString())))...[
                                      IconButton(
                                        icon: const Icon(Icons.assignment_turned_in),
                                        onPressed: () async {
                                          await listOfDocumentSnap[index]
                                              .reference
                                              .update({'done':true});
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () async {
                                          var todoId= listOfDocumentSnap[index].id;
                                          await listOfDocumentSnap[index]
                                              .reference
                                              .delete();
                                          _usersRef.doc(userId).update({'todo_list':FieldValue.arrayRemove([todoId])});
                                        },
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  _showDialog(BuildContext context){

    BlurryDialog  alert = BlurryDialog("Are you sure you want to exit?",(){
      Navigator.of(context).pop();
      _auth.signOut();
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

