import 'package:flutter/material.dart';
import 'injection/dependency_injection.dart';
import 'module/league/round_groups_view.dart';

void main() {
  Injector.configure(Flavor.MOCK);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Catchess",
      theme: new ThemeData(
        // TODO review style
        primaryColor: Color(0xFF00BCD4),
        secondaryHeaderColor: Color(0xFF4DD0E1),
        accentColor: Color(0xFFFFA726),
        fontFamily: "UbuntuCondensed",
      ),
      home: Scaffold(
        body: RoundGroupsPage(),
      ),
    );
  }
}
