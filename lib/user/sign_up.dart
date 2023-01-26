import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salemapp/component/alert.dart';

class Sign_up extends StatefulWidget {
  const Sign_up({Key? key}) : super(key: key);

  @override
  _Sign_upState createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  var memail, mpasswoard,meuser;

  signup() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        showLoding(context);
        UserCredential credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: memail,
          password: mpasswoard,

        );
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showLoding(context);
          AwesomeDialog(
              context: context,
              title: "error",
              body: Text("weak-password"),
              dialogType: DialogType.ERROR)
            ..show();
        } else if (e.code == 'email-already-in-use') {
          showLoding(context);
          print('The account already exists for that email.');
          AwesomeDialog(
              context: context,
              title: "error",
              body: Text("The account already exists for that email."),
              dialogType: DialogType.ERROR)
            ..show();
        }
      } catch (e) {
        print(e);
      }
    } else {
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
                      meuser = val;
                    },
                    validator: (val) {},
                    decoration: InputDecoration(
                        hintText: "user name",
                        prefix: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(50))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onSaved: (val) {
                      memail = val;
                    },
                    validator: (val) {},
                    decoration: InputDecoration(
                        hintText: "Email",
                        prefix: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(50))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onSaved: (val) {
                      mpasswoard = val;
                    },
                    validator: (val) {},
                    decoration: InputDecoration(
                        hintText: "password",
                        prefix: Icon(
                          Icons.password,
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(50))),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text("      if you have account?    "),
                        InkWell(
                          child: Text(
                            "sign in account",
                            style: TextStyle(color: Colors.blue),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed("login");
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        var resp = await signup();
                        if (resp != null) {
                          await FirebaseFirestore.instance.collection("users").add({
                            "user name": meuser,
                            "email": memail

                          });
                          Navigator.of(context).pushReplacementNamed("login");
                        }
                      },
                      child: Text("Sign up"),
                    ),
                    margin: EdgeInsets.all(30),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
