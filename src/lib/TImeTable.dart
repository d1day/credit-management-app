import 'package:flutter/material.dart';
import 'package:test_project/base_component.dart';

// バーの色
const colorBar = Color.fromARGB(255, 122, 204, 241);
// 学期
const lstSemestar = ['前期', '後期'];
// 時間数
final numHour = 6;
// 曜日
final numDay = 6;

class TimeTable extends StatefulWidget {
  const TimeTable({super.key, required this.title});

  final String title;

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  @override
  Widget build(BuildContext context) {
    // 年度のリスト
    List<String> lstYear = List<String>.empty(growable: true);
    var nYear = DateTime.now().year;
    for (int i = -10; i < 10; i++) {
      lstYear.add((nYear + i).toString());
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CmbBase(
                  list: lstYear,
                  color: colorBar,
                  firstIndex: 10,
                ),
                const Text(
                  '年度 ',
                  style: TextStyle(fontSize: 19),
                ),
                const CmbBase(list: lstSemestar, color: colorBar)
              ]),
          backgroundColor: colorBar,
        ),
        drawer: Drawer(
          child: ListView(children: const [ListTile(title: Text('メニュー１'))]),
        )
        // body: Table(
        //   children: TableRows(),
        // )
        );
  }
}
