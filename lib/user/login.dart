import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/alert.dart';


class Sign extends StatefulWidget {
  const Sign({Key? key}) : super(key: key);

  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Sign> {
  GlobalKey<FormState> formstate =  GlobalKey<FormState>();
  var memail, mpasswoard;
  Signin() async{
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        showLoding(context);
        UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: memail,
            password: mpasswoard

        );
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
           AwesomeDialog(
              context: context,
              title: "error",
              body: Text("user-not-found"),
              dialogType: DialogType.ERROR)
            .show();
          print('No user found for that email.');
          AwesomeDialog(context: context,title: "error", body: Text("No user found for that email"),dialogType: DialogType.ERROR);
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();

          AwesomeDialog(
              context: context,
              title: "error",
              body: Text("wrong-password"),
              dialogType: DialogType.ERROR)
            .show();
          print('Wrong password provided for that user.');
          AwesomeDialog(context: context,title: "error", body: Text("Wrong password provided for that user"),dialogType: DialogType.ERROR);

        }
      }
    }else{
      print("not valid");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        children: [
          Container(
            child: Image.asset(
              "image/note.jpg",
              height: 300,
              width: 200,
            ),
            alignment: Alignment.center,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: formstate,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (val) {
                      memail = val;
                    },
                    validator: (val) {

                    },
                    decoration: InputDecoration(
                        hintText: "Email",
                        prefix: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(50))),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    onSaved: (val) {
                      mpasswoard = val;
                    },
                    validator: (val) {

                    },
                    decoration: InputDecoration(
                        hintText: "password",
                        prefix: Icon(Icons.password,),
                        border: OutlineInputBorder(borderSide:BorderSide(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(50))),),
                  Container(child: Row( children: [
                    const Text("     if you havent account?    "),
                    InkWell(child: const Text("new account", style: TextStyle(color: Colors.blue),),onTap: (){
                      Navigator.of(context).pushNamed("signup");
                    },)
                  ],),),
                  Container(child: ElevatedButton(onPressed: () async{
                    var user = await Signin();
                    if(user != null){
                      Navigator.of(context).pushReplacementNamed("home");
                    }
                  } , child: Text("Sign in"), ), margin: EdgeInsets.all(30),)

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
