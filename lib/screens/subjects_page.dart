import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_notes/custom_widgets/button.dart';
import 'package:google_notes/custom_widgets/input_box.dart';
import 'package:google_notes/utilities/constants.dart';

class SubjectsPage extends StatefulWidget {
  static const routeName = 'SubjectsPage';

  @override
  _SubjectsPageState createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  final _fireStore = Firestore.instance;
  var subjectBox = InputBox(
    text: 'Subject',
    hintText: 'Enter Subject Name',
    textCapitalization: TextCapitalization.words,
  );
  var len;
  @override
  Widget build(BuildContext context) {

    _fireStore.collection('subjectname').snapshots().length.then((val) {
      len = val;
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Subjects'),
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
                          text: [
                            'Add Subject',
                          ],
                          textAlign: TextAlign.left,
                          duration: Duration(seconds: 4),
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
                                    .collection('subjectname')
                                    .document(subjectBox.input)
                                    .setData(
                                  {'subject': subjectBox.input},
                                );
                                Navigator.pop(context);
                                setState(() {});
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
        body: GridView.count(
          crossAxisCount: 2,
          children: List.generate(
            len,
            (index) {
              return StreamBuilder(
                stream: _fireStore.collection('subjectname').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blueGrey,
                      ),
                    );
                  }
                  var allSubjects = snapshot.data.documents;
                  print(allSubjects[index]);
                  return GridTile(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            kBlueColor.withOpacity(0.7),
                            kBlueColor.withOpacity(0.8),
                            kBlueColor.withOpacity(0.9),
                            kBlueColor,
                          ],
                          stops: [0.2, 0.4, 0.6, 0.9],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          allSubjects[index]['subject'],
                          style: kInputBoxInputTextStyle.copyWith(
                              color: Colors.white),
                        ),
                      ),
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
