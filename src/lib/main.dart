import 'package:flutter/material.dart';
import 'time_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TimeTable.nDeviceWidth = MediaQuery.of(context).size.width;
    TimeTable.nDeviceHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TimeTable(),
    );
  }
}
