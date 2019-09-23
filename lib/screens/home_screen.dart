import 'package:flutter/material.dart';
import 'package:google_notes/custom_widgets/input_box.dart';
import 'package:google_notes/custom_widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class NotesPage extends StatefulWidget {
  static const routeName = 'NotesPage';
  final subject;

  NotesPage({@required this.subject});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _fireStore = Firestore.instance;
  bool showSpinner = false;
  var subjectBox = InputBox(
    text: 'Note',
    hintText: 'Enter note here',
    textCapitalization: TextCapitalization.words,
  );
  var len;
  var subjectNotes;

  @override
  Widget build(BuildContext context) {
    _fireStore
        .collection('subjects')
        .where('subject', isEqualTo: widget.subject)
        .snapshots()
        .length
        .then((val) {
      len = val;
    });
    subjectNotes = _fireStore
        .collection('subjects')
        .where('subject', isEqualTo: widget.subject)
        .snapshots();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.subject),
          backgroundColor: Colors.black,
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: TypewriterAnimatedTextKit(
                          text: ['Add Note', 'Keep the note short !'],
                          textAlign: TextAlign.left,
                          duration: Duration(seconds: 12),
                        ),
                        content: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Center(child: subjectBox),
                            ),
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
                                    'subject': widget.subject,
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
                }),
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: StreamBuilder(
            stream: _fireStore
                .collection('subjects')
                .where('subject', isEqualTo: widget.subject)
                .snapshots(),
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
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(FontAwesomeIcons.google),
                        onPressed: () {
                          FlutterWebBrowser.openWebPage(
                            url:
                                'https://www.google.com/search?q=${notes[index]['note']}',
                            androidToolbarColor: Colors.white,
                          );
                        },
                      ),
                      title: GestureDetector(
                        onTap: () {
                          FlutterWebBrowser.openWebPage(
                            url:
                                'https://www.google.com/search?q=${notes[index]['note']}',
                            androidToolbarColor: Colors.white,
                          );
                        },
                        child: Text(
                          notes[index]['note'],
                        ),
                      ),
                      subtitle: GestureDetector(
                        onTap: () {
                          FlutterWebBrowser.openWebPage(
                            url:
                                'https://www.google.com/search?q=${notes[index]['note']}',
                            androidToolbarColor: Colors.white,
                          );
                        },
                        child: Text(
                          notes[index]['date'].toString(),
                        ),
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
//        floatingActionButton: FloatingActionButton(
//          onPressed: () {
//            showDialog(
//              context: context,
//              builder: (context) {
//                return AlertDialog(
//                  title: TypewriterAnimatedTextKit(
//                    text: ['Add Note', 'Keep the note short !'],
//                    textAlign: TextAlign.left,
//                    duration: Duration(seconds: 12),
//                  ),
//                  content: Column(
//                    children: <Widget>[
//                      Expanded(
//                        flex: 4,
//                        child: Center(child: subjectBox),
//                      ),
//                      Button(
//                        text: 'ADD',
//                        onPressed: () {
//                          _fireStore
//                              .collection('subjects')
//                              .document(DateTime.now()
//                                  .millisecondsSinceEpoch
//                                  .toString())
//                              .setData(
//                            {
//                              'note': subjectBox.input,
//                              'date': DateTime.now().day.toString() +
//                                  '/' +
//                                  DateTime.now().month.toString() +
//                                  '/' +
//                                  DateTime.now().year.toString(),
//                              'subject': widget.subject,
//                            },
//                          );
//                          Navigator.pop(context);
//                        },
//                      ),
//                    ],
//                  ),
//                );
//              },
//            );
//          },
//          child: Icon(Icons.add),
//        ),
      ),
    );
  }
}
