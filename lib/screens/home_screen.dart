import 'package:flutter/material.dart';
import 'package:google_notes/custom_widgets/input_box.dart';
import 'package:google_notes/custom_widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotesPage extends StatefulWidget {
  static const routeName = 'NotesPage';

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _fireStore = Firestore.instance;
  bool showSpinner = false;
  var subjectBox = InputBox(text: 'Note', icon: Icon(Icons.library_books));

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
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueGrey,
                  ),
                );
              }
              var notes = snapshot.data.documents;
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {},
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(FontAwesomeIcons.google),
                        onPressed: () {
                          setState(() {
                            _fireStore
                                .collection('subjects')
                                .document(notes[index].documentID)
                                .delete();
                          });
                        },
                      ),
                      title: Text(
                        notes[index]['note'],
                      ),
                      subtitle: Text(
                        notes[index]['date'].toString(),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () {
                          setState(() {
                            _fireStore
                                .collection('subjects')
                                .document(notes[index].documentID)
                                .delete();
                          });
                        },
                      ),
                    ),
                  );
                },
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
                  title: Text('Add Note'),
                  content: ListView(
                    children: <Widget>[
                      subjectBox,
                      Button(
                        text: 'ADD',
                        onPressed: () {
                          _fireStore
                              .collection('subjects')
                              .document(DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString())
                              .setData(
                            {
                              'note': subjectBox.input,
                              'date': DateTime.now().day.toString() +
                                  '/' +
                                  DateTime.now().month.toString() +
                                  '/' +
                                  DateTime.now().year.toString(),
                            },
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
