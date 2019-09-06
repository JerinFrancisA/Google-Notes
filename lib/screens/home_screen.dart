import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SubjectsPage extends StatefulWidget {
  static const routeName = 'SubjectsPage';

  @override
  _SubjectsPageState createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  final _fireStore = Firestore.instance;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: StreamBuilder(
            stream: _fireStore.collection('subjects').snapshots(),
            builder: (context, snapshot) {
              while (!snapshot.hasData) {
                setState(() {
                  showSpinner = true;
                });
              }
              setState(() {
                showSpinner = false;
              });
              var notes = snapshot.data.documents;
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {

                    },
                    child: ListTile(
                      title: Text('${notes[index].data['note']}'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
