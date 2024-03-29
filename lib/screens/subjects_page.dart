import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_notes/custom_widgets/button.dart';
import 'package:google_notes/custom_widgets/input_box.dart';
import 'package:google_notes/screens/home_screen.dart';
import 'package:google_notes/utilities/constants.dart';
import 'package:google_notes/utilities/image_links.dart';

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
    textCapitalization: TextCapitalization.characters,
  );

  var len;

  Future<String> getLen() async {
    String dupLen;
    await Firestore.instance
        .collection('subjectname')
        .getDocuments()
        .then((myDocuments) {
      dupLen = myDocuments.documents.length.toString();
    });
    return dupLen;
  }

  Future<void> ll() async {
    len = int.parse(await getLen());
    print(len);
  }

  @override
  Widget build(BuildContext context) {
    ll();
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
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(
              len ?? 0,
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
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotesPage(
                                subject: allSubjects[index]['subject'],
                              ),
                            ),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                  'Confirm Delete ${allSubjects[index]['subject']} ?',
                                ),
                                actions: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: GestureDetector(
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Text(
                                                'No',
                                                textAlign: TextAlign.center,
                                                style: kInputBoxStyle.copyWith(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                shape: BoxShape.rectangle,
                                                color: kRedColor),
                                            width: 100.0,
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: GestureDetector(
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Text(
                                                'Yes',
                                                textAlign: TextAlign.center,
                                                style: kInputBoxStyle.copyWith(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                shape: BoxShape.rectangle,
                                                color: kRedColor),
                                            width: 100.0,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _fireStore
                                                  .collection('subjectname')
                                                  .document(allSubjects[index]
                                                      .documentID)
                                                  .delete();
                                              ll();
                                              len = len - 1;
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: GridTile(
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    (index % 4 == 0)
                                        ? kRedColor.withOpacity(1.0)
                                        : (index % 4 == 1)
                                            ? kGreenColor.withOpacity(1.0)
                                            : (index % 4 == 2)
                                                ? kBlueColor.withOpacity(1.0)
                                                : kYellowColor.withOpacity(1.0),
                                    (index % 4 == 0)
                                        ? kRedColor.withOpacity(0.75)
                                        : (index % 4 == 1)
                                            ? kGreenColor.withOpacity(0.75)
                                            : (index % 4 == 2)
                                                ? kBlueColor.withOpacity(0.75)
                                                : kYellowColor
                                                    .withOpacity(0.75),
                                    (index % 4 == 0)
                                        ? kRedColor.withOpacity(0.75)
                                        : (index % 4 == 1)
                                            ? kGreenColor.withOpacity(0.75)
                                            : (index % 4 == 2)
                                                ? kBlueColor.withOpacity(0.75)
                                                : kYellowColor
                                                    .withOpacity(0.75),
                                    (index % 4 == 0)
                                        ? kRedColor.withOpacity(1.0)
                                        : (index % 4 == 1)
                                            ? kGreenColor.withOpacity(1.0)
                                            : (index % 4 == 2)
                                                ? kBlueColor.withOpacity(1.0)
                                                : kYellowColor.withOpacity(1.0),
                                  ],
                                  stops: [0.1, 0.4, 0.6, 0.9],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image(
                                      image: NetworkImage(images[
                                          Random().nextInt(images.length)]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    allSubjects[index]['subject'],
                                    style: kInputBoxInputTextStyle.copyWith(
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
