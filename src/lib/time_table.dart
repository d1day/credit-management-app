import 'package:flutter/material.dart';
import 'base_component.dart';
import 'cls_insert.dart';

// デザイン
// バーの色
const colorBar = Color.fromARGB(255, 169, 210, 243);
// ボトムバーの高さ
const double nBnbHeight = 60;
// 枠線の太さ
const double nWidth = 0.5;
// 時間の列の幅
double nWidthHour = 0;
// 曜日の行の高さ
double nHeightDay = 0;
// 通常のセルの幅
double nWidthCell = 0;
// 通常のセルの高さ
double nHeightCell = 0;
// 表の丸み
double nRadius = 5;
// 左右のスペース
const double nSideSpace = 10;
// 上下のスペース
const double nTopAndBottomSpace = 20;
// 表の色
const Color colorItem = Color.fromARGB(255, 169, 210, 243);
// 表の文字の色
const Color colorItemText = Colors.black;

// 時間数
final int numHour = 6;
// 曜日
final int numDay = 6;

class TimeTable extends StatelessWidget {
  const TimeTable(
      {super.key, required this.nDeviceWidth, required this.nDeviceHeight});
  //
  final double nDeviceWidth;
  final double nDeviceHeight;

  //時間割取得
  getTimeTable(int nYear, String strClsSemestar) {}

  @override
  Widget build(BuildContext context) {
    // 年度のリスト
    List<String> lstYear = List<String>.empty(growable: true);
    var nYear = DateTime.now().year;
    for (int i = -10; i < 10; i++) {
      lstYear.add((nYear + i).toString());
    }

    final clrAppBarHeight = AppBar().preferredSize.height;
    nWidthHour = nDeviceWidth / 14;
    nHeightDay = nDeviceHeight / 20;
    nWidthCell = (nDeviceWidth - nWidthHour - (nSideSpace * 2)) / numDay;
    nHeightCell = (nDeviceHeight -
                clrAppBarHeight -
                nHeightDay -
                (nTopAndBottomSpace * 2) -
                nBnbHeight) /
            numHour -
        5;

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
            padding: const EdgeInsets.fromLTRB(
                nSideSpace, nTopAndBottomSpace, nSideSpace, nTopAndBottomSpace),
            child: Column(
              children: <Widget>[
                for (int nRow = 0; nRow < numHour + 1; nRow++)
                  Row(children: [
                    for (int nCol = 0; nCol < numDay + 1; nCol++)
                      createTimeTableCell(nRow, nCol),
                  ])
              ],
            )),
        bottomNavigationBar: SizedBox(
            height: nBnbHeight,
            child: BottomNavigationBar(items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.apps_rounded, color: Colors.white),
                  label: '時間割'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.assessment_outlined, color: Colors.white),
                  label: '単位管理'),
            ], onTap: _onBnbTap, backgroundColor: colorItem)));
  }
}

Widget createTimeTableCell(int nRow, int nCol) {
  if (nRow == 0 && nCol == 0) {
    // 左上の空白
    return SizedBox(
      height: nHeightDay,
      width: nWidthHour,
    );
  } else if (nRow == 0) {
    // 曜日
    return Container(
        width: nWidthCell,
        height: nHeightDay,
        decoration: BoxDecoration(
            border: Border.all(width: nWidth, color: Colors.white),
            color: colorItem,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(nCol == 1 ? nRadius : 0),
                topRight: Radius.circular(nCol == numDay ? nRadius : 0))),
        child: Center(
            child: Text(
          lstDay[numDay != lstDay.length ? nCol : nCol - 1],
          style: const TextStyle(color: colorItemText),
        )));
  } else if (nCol == 0) {
    // 数字
    return Container(
        width: nWidthHour,
        height: nHeightCell,
        decoration: BoxDecoration(
            border: Border.all(width: nWidth, color: Colors.white),
            color: colorItem,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  nRow == 1 ? nRadius : 0,
                ),
                bottomLeft: Radius.circular(nRow == numHour ? nRadius : 0))),
        child: Center(
            child: Text(
          nRow.toString(),
          style: const TextStyle(color: colorItemText),
        )));
  } else {
    // 授業
    return TimeTableCell(
        strIdLesson: 'a',
        strNmDay: lstDay[numDay != lstDay.length
            ? nCol < lstDay.length - 1
                ? nCol
                : 0
            : nCol != 7
                ? nCol
                : 0],
        nHour: nRow);
  }
}

// ボトムバータップ
void _onBnbTap(int index) {}

// 授業用のセル
class TimeTableCell extends StatefulWidget {
  const TimeTableCell(
      {super.key,
      required this.strIdLesson,
      required this.strNmDay,
      required this.nHour});
  final String strIdLesson;
  final String strNmDay;
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
              context, widget.strIdLesson, widget.strNmDay, widget.nHour);
        },
        child: Container(
          height: nHeightCell,
          width: nWidthCell,
          decoration: BoxDecoration(
              border: Border.all(width: nWidth, color: colorItem)),
          // child: Text(widget.strCdDay + widget.nHour.toString()),
        ));
  }
}
