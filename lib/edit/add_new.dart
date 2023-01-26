import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:salemapp/component/alert.dart';
import 'package:image_picker/image_picker.dart';

class add_new extends StatefulWidget {
  const add_new({Key? key}) : super(key: key);

  @override
  State<add_new> createState() => _add_newState();
}

class _add_newState extends State<add_new> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  var _title, _desc;
  late File _file;
  Reference _reference = FirebaseStorage.instance.ref();

  ImagePicker _imagePicker4 = ImagePicker();
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("notes");

  addnote() async {
    showLoding(context);
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();

      await _collectionReference.add({
        "title": _title,
        "description": _desc,
        "uid": FirebaseAuth.instance.currentUser!.uid
      });
      Navigator.of(context).pushNamed("home");

    }
  }

  showDialogAdd(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Choose"),
              content: Container(
                height: 120,
                child: Column(
                  children: [
                    InkWell(
                      child: Row(children: [
                        IconButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            var piked = await _imagePicker4.getImage(
                                source: ImageSource.gallery);
                            if (piked != null) {
                              _file = File(piked.path);
                              await _reference.putFile(_file);
                            }
                          },
                          icon: Icon(Icons.browse_gallery),
                        ),
                        Text("From gallary")
                      ]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              Navigator.of(context).pop();

                              var piked = await _imagePicker4.getImage(
                                  source: ImageSource.camera);
                              if (piked != null) {
                                _file = File(piked.path);
                                await _reference.putFile(_file);
                              }
                            },
                            icon: Icon(Icons.camera)),
                        Text("from camera")
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add note",)),
      body: Container(
        margin: EdgeInsets.only(top: 80),
        child: Column(children: [
          Form(
              child: Column(
            children: [
              Form(
                key: formstate,
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (val) {
                        _title = val;
                      },
                      validator: (val) {
                        if (val!.length > 10) {
                          return "pleas enter title between 1 - 10 ";
                        }
                        if (val.length < 3) {
                          return "pleas add letters between 1 - 10 ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "title",
                          prefixIcon: Icon(Icons.title),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.red,
                                  style: BorderStyle.solid))),
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      onSaved: (val) {
                        _desc = val;
                      },
                      validator: (val) {
                        if (val!.length > 255) {
                          return "pleas enter title between 1 - 255 ";
                        }
                        if (val.length < 2) {
                          return "pleas add letters between 5 - 255 ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "description",
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.red,
                                  style: BorderStyle.solid))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  await showDialogAdd(context);
                },
                child: Text("select image"),
              ),
            ],
          )),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
              onPressed: () async {
                await addnote();
              },
              child: Text("Add"))
        ]),
      ),
    );
  }
}
