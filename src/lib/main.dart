import 'package:flutter/material.dart';
import 'time_table.dart';
//import 'db_helper.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final nDeviceWidth = MediaQuery.of(context).size.width;
    final nDeviceHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TimeTable(nDeviceWidth: nDeviceWidth, nDeviceHeight: nDeviceHeight),
    );
  }
}
