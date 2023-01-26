import 'package:flutter/material.dart';

class view_note extends StatefulWidget {
  final list;

  const view_note({Key? key, this.list}) : super(key: key);

  @override
  State<view_note> createState() => _view_noteState();
}

class _view_noteState extends State<view_note> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("note"),
        ),
        body: Container(
          child: Column(
            children: [
              Text("${widget.list['title']}", style: TextStyle(fontSize: 25)),
              SizedBox(height: 30,),
              Text("${widget.list['description']}",
                  style: TextStyle(fontSize: 18))
            ],
          ),
        ));
  }
}
