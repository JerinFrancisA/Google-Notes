import 'package:flutter/material.dart';
import 'package:google_notes/custom_widgets/input_box.dart';
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
  var subjectBox = InputBox(text: 'Subject', icon: Icon(Icons.library_books));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: StreamBuilder(
            stream: _fireStore.collection('subjects').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var notes = snapshot.data.documents;
              return Column(
                children: <Widget>[
                  ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {},
                        child: ListTile(
                          title: Text('${notes[index].data['note']}'),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Add Subject'),
                    content: subjectBox,
                  );
                });
            _fireStore
                .collection('subjects')
                .document(subjectBox.input)
                .setData({});
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
