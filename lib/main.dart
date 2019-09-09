import 'package:flutter/material.dart';
import 'package:google_notes/screens/home_screen.dart';
import 'package:google_notes/screens/subjects_page.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gnote',
      initialRoute: SubjectsPage.routeName,
      routes: {
        SubjectsPage.routeName: (context) => SubjectsPage(),
        NotesPage.routeName: (context) => NotesPage()
      },
    );
  }
}
