import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leaders_of_digital_hack/ui/screens/dashboard_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(DashboardApp());
}

class DashboardApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leaders Of Digital Hack Solution',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          accentColor: Colors.blueAccent,
          textTheme: TextTheme(
              headline6: GoogleFonts.lato(),
              bodyText1: GoogleFonts.lato(),
              headline5: GoogleFonts.lato())),
      home: DashboardPage(),
    );
  }
}
