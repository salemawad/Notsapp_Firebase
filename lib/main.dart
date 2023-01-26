import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:salemapp/edit/add_new.dart';
import 'package:salemapp/edit/editnote.dart';
import 'package:salemapp/edit/viewnotes.dart';
import 'package:salemapp/user/login.dart';
import 'package:salemapp/user/sign_up.dart';

import 'Home.dart';

bool? islogin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    islogin = false;
  } else {
    islogin = true;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: islogin == false ? Sign() : Homepage(),
      debugShowCheckedModeBanner: false,
      routes: {
        "signup": (context) => Sign_up(),
        "login": (context) => Sign(),
        "home": (context) => Homepage(),
        "addnew": (context) => add_new(),
        "edit" : (context)=> editnotes(),
        "view": (context)=> view_note()
      },
    );
  }
}
//
// class Homepage extends StatefulWidget {
//   const Homepage({Key? key}) : super(key: key);
//
//   @override
//   _HomepageState createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepage> {
//   late File file;
//
//   var imagpik = ImagePicker();
//
//   List notes = [
//     {"note": " salem salem salem vsalem salem salem"},
//     {"note": " salem salem salem vsalem salem salem"},
//     {"note": " salem salem salem vsalem salem salem"}
//   ];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("homepage"),
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 await FirebaseAuth.instance.signOut();
//                 Navigator.of(context).pushReplacementNamed("login");
//               },
//               icon: Icon(Icons.exit_to_app))
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).pushNamed("addnew");
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.blue,
//       ),
//       body: Container(
//         child: ListView.builder(
//             itemCount: notes.length,
//             itemBuilder: (context, i) {
//               return Dismissible(
//                   key: Key("$i"),
//                   child: lista(
//                     notes: notes[i],
//                   ));
//             }),
//       ),
//     );
//   }
// }
//
// class lista extends StatelessWidget {
//   final notes;
//
//   lista({this.notes});
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Card(
//         child: ListTile(
//       title: Text("${notes['note']}"),
//       trailing: IconButton(
//         icon: Icon(Icons.edit),
//         onPressed: () {},
//       ),
//     ));
//   }
// }
