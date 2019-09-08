import 'package:flutter/material.dart';
import 'package:google_notes/screens/home_screen.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gnote',
      initialRoute: NotesPage.routeName,
      routes: {
        NotesPage.routeName: (context) => NotesPage()
      },
    );
  }
}
