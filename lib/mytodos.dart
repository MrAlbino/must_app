import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user =_auth.currentUser;
final userId = user!.uid;

class MyTodosPage extends StatefulWidget{
  const MyTodosPage({Key? key}) : super(key: key);

  @override
  _MyTodosPageState createState()=> _MyTodosPageState();
}


class _MyTodosPageState extends State<MyTodosPage>{
  final _fs=  FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    CollectionReference todosRef= _fs.collection('todos');
    CollectionReference _usersRef= _fs.collection('Users');
    //var _usersRef =_fs.collection('DriverList');
   //var userSnapshot = _usersRef.get();
   // var userData =_fs.collection('Users').doc(userId);


   // Future<String> getTodos(String _userId) async {
   //  DocumentReference documentReference = _usersRef.doc(_userId);
    //  String value='';
    //  documentReference.get().then((snapshot) {
    //    value=(snapshot['todo_list'].toString());

    //  });
    //  return value;
   // }

    //var user_todos=getTodos(userId);

    DocumentReference documentReference = _usersRef.doc(userId);









    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title:  Text("MUST",
          style: GoogleFonts.pacifico(fontSize: 25,color:Colors.white),

        ),
        centerTitle: true,
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
                              color: (DateTime.now().isBefore(DateTime.parse((listOfDocumentSnap[index]['deadline']).toDate().toString())) ? Colors.yellow:Colors.red) ,
                              child: ListTile(
                                title: Text(
                                    '${listOfDocumentSnap[index]['name']}',
                                    style: const TextStyle(fontSize: 24)),
                                subtitle: Text(
                                    '${DateTime.parse((listOfDocumentSnap[index]['deadline']).toDate().toString())}',
                                    style: const TextStyle(fontSize: 16)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    var todoId= listOfDocumentSnap[index].id;
                                    await listOfDocumentSnap[index]
                                        .reference
                                        .delete();
                                    _usersRef.doc(userId).update({'todo_list':FieldValue.arrayRemove([todoId])});
                                  },
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
}
