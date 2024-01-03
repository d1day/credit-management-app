import 'package:flutter/material.dart';
import 'base_component.dart';
import 'package:sqflite/sqflite.dart';

// バーの色
const colorBar = Color.fromARGB(255, 122, 204, 241);
// 枠線の太さ
const nWidth = 0.5;
// 時間数
int numHour = 6;
// 曜日
int numDay = 6;

class TimeTable extends StatelessWidget {
  const TimeTable({super.key});

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
        ),
        body: Padding(
            padding: const EdgeInsets.only(right: 30, bottom: 30),
            child: GridView.builder(
              itemCount: (numDay + 1) * (numHour + 1),
              itemBuilder: (context, index) {
                return createTimeTableCell(index);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numDay + 1, childAspectRatio: 1 / 1.5),
            )));
  }
}

Widget createTimeTableCell(int index) {
  if (index == 0) {
    // 左上の空白
    return Container();
  } else if (index < numDay + 1) {
    // 曜日
    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: nWidth, color: Colors.white),
              color: const Color.fromARGB(255, 58, 165, 253),
            ),
            child: Center(
                child: Text(
              lstDay[numDay != 7 ? index : index - 1],
              style: const TextStyle(color: Colors.white),
            ))));
  } else if (index % (numDay + 1) == 0) {
    // 数字
    return Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: nWidth, color: Colors.white),
                color: const Color.fromARGB(255, 58, 165, 253)),
            width: 30,
            child: Center(
                child: Text(
              (index / (numDay + 1)).floor().toString(),
              style: const TextStyle(color: Colors.white),
            ))));
  } else {
    // 授業
    return TimeTableCell(
        strIdLesson: 'a',
        strCdDay: lstCdDay[numDay != 7
            ? ((index + 1) % (numDay + 1) + numDay) % (numDay + 1)
            : ((index + 1) % (numDay + 1) + (numDay - 1)) % (numDay + 1)],
        nHour: (index / (numDay + 1)).floor());
  }
}

// 授業選択時
void selectLesson(
    BuildContext context, String strIdLesson, String strCdDay, int nHour) {
  // 画面遷移時の処理
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => Next(
        strCdDay: strCdDay,
        nHour: nHour,
      ),
    ),
  );
}

//授業・単位数登録画面
class Next extends StatefulWidget {
  final String strCdDay;
  final int nHour;
  @override
  Next({required this.strCdDay, required this.nHour});
  _NextState createState() => _NextState();
}

class _NextState extends State<Next> {
  @override
  Widget build(BuildContext context) {
    String resultText = widget.strCdDay + widget.nHour.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(resultText),
      ),
      body: Container(
        child: Column(children: [
          TextField(),
          TextField(),
        ]),
      ),
    );
  }
}

// 授業用のセル
class TimeTableCell extends StatefulWidget {
  const TimeTableCell(
      {super.key,
      required this.strIdLesson,
      required this.strCdDay,
      required this.nHour});
  final String strIdLesson;
  final String strCdDay;
  final int nHour;

  @override
  State<TimeTableCell> createState() => _TimeTableCellState();
}

class _TimeTableCellState extends State<TimeTableCell> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          selectLesson(
              context, widget.strIdLesson, widget.strCdDay, widget.nHour);
        },
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: nWidth)),
          // child: Text(widget.strCdDay + widget.nHour.toString()),
        ));
  }
}
