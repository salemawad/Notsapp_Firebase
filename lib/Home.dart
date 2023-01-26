import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salemapp/component/alert.dart';
import 'package:salemapp/edit/editnote.dart';
import 'package:salemapp/edit/viewnotes.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("notes");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("homepage"),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed("login");
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("addnew");
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
        body: Container(
            child: FutureBuilder(
                future: _collectionReference
                    .where("uid",
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .get(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          // return Text("${snapshot.data!.docs[i]['title'].data()['title']}");
                          return Dismissible(
                            onDismissed: (val) async {
                              AwesomeDialog(
                                  context: context,
                                  title: "are you sure",
                                  body: Text(
                                      "Are you sure you want to delete the note?"),
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.WARNING,
                                  btnOk: ElevatedButton(
                                    child:Text("yes") ,
                                    onPressed: () async{
                                      await _collectionReference
                                          .doc(snapshot.data!.docs[i].id)
                                          .delete();},),
                                  btnCancel: ElevatedButton(
                                    child:Text("No") ,
                                    onPressed: () {

                                    }
                                  )

                              )
                                ..show();
                            },
                            key: UniqueKey(),
                            child: list_a(
                              note_s: snapshot.data!.docs[i],
                              docid: snapshot.data!.docs[i].id,
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })));
  }
}

class list_a extends StatelessWidget {
  final note_s;
  final docid;

  list_a({this.note_s, this.docid});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap:(){Navigator.of(context).push(MaterialPageRoute(builder: (context){
        return view_note(list: note_s,);
      }));} ,
      child: Card(
          child: ListTile(
        title: Text("${note_s['title']}"),
        subtitle: Text("${note_s['description']}"),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            // Navigator.of(context).pushReplacementNamed("edit");
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return editnotes(
                docid: docid,
                list: note_s,
              );
            }));
          },
        ),
      )),
    );
    ;
  }
}
