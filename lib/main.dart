import 'package:flutter/material.dart';
import 'package:pv_time_estimate/widgets/input_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'Fabrication Estimation',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: InputForm(),
    );
  }
}
