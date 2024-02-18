import 'package:flutter/material.dart';
import 'base_component.dart';
import 'cls_insert.dart';
import 'db_helper.dart';

// デザイン
// バーの色
const colorBar = Color.fromARGB(255, 169, 210, 243);
// ボトムバーの高さ
const double nBnbHeight = 60;
// 枠線の太さ
const double nWidth = 0.5;
// 時間の列の幅
double nWidthPeriod = 0;
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

// 時間割リスト
List<Map> tblTimeTable = List<Map>.empty(growable: true);

// 時間数
final int numPeriod = 6;
// 曜日
final int numDay = 6;

class TimeTable extends StatelessWidget {
  TimeTable(
      {super.key, required this.nDeviceWidth, required this.nDeviceHeight});
  //
  final double nDeviceWidth;
  final double nDeviceHeight;

  String? strYear;
  String? strClsSemestar;

  //時間割取得
  static Future<List<Map>> getTimeTable(
      String strYear, String strClsSemestar) async {
    int nYear = 0;
    if (strYear != "null" && strClsSemestar != "null") {
      nYear = int.parse(strYear);
    }
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map> result =
        await dbHelper.selectTimeTableData(nYear, strClsSemestar);
    return Future<List<Map>>.value(result);
  }

  void setTimeTableCell(String strNmDay, int nPeriod) {
    for (int i = 0; i < tblTimeTable.length; i++) {
      tblTimeTable[i]['nm_lecture'];
    }
  }

  @override
  Widget build(BuildContext context) {
    // 年度のリスト
    List<String> lstYear = List<String>.empty(growable: true);
    var nYear = DateTime.now().year;
    for (int i = -10; i < 10; i++) {
      lstYear.add((nYear + i).toString());
    }

    final clrAppBarHeight = AppBar().preferredSize.height;
    nWidthPeriod = nDeviceWidth / 14;
    nHeightDay = nDeviceHeight / 20;
    nWidthCell = (nDeviceWidth - nWidthPeriod - (nSideSpace * 2)) / numDay;
    nHeightCell = (nDeviceHeight -
                clrAppBarHeight -
                nHeightDay -
                (nTopAndBottomSpace * 2) -
                nBnbHeight) /
            numPeriod -
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
                  onSelect: (String? str) {
                    strYear = str;
                    if (strYear != null && strClsSemestar != null) {
                      getTimeTable(
                              strYear.toString(), strClsSemestar.toString())
                          .then((value) => tblTimeTable = value);
                    }
                  },
                ),
                const Text(
                  '年度 ',
                  style: TextStyle(fontSize: 19),
                ),
                CmbBase(
                  list: lstSemestar,
                  color: colorBar,
                  onSelect: (String? str) {
                    strClsSemestar = str;
                    if (strYear != null && strClsSemestar != null) {
                      getTimeTable(
                              strYear.toString(), strClsSemestar.toString())
                          .then((value) => tblTimeTable = value);
                    }
                  },
                )
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
                for (int nRow = 0; nRow < numPeriod + 1; nRow++)
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

  Widget createTimeTableCell(int nRow, int nCol) {
    if (nRow == 0 && nCol == 0) {
      // 左上の空白
      return SizedBox(
        height: nHeightDay,
        width: nWidthPeriod,
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
          width: nWidthPeriod,
          height: nHeightCell,
          decoration: BoxDecoration(
              border: Border.all(width: nWidth, color: Colors.white),
              color: colorItem,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    nRow == 1 ? nRadius : 0,
                  ),
                  bottomLeft:
                      Radius.circular(nRow == numPeriod ? nRadius : 0))),
          child: Center(
              child: Text(
            nRow.toString(),
            style: const TextStyle(color: colorItemText),
          )));
    } else {
      // 授業
      return TimeTableCell(
          strNmDay: lstDay[numDay != lstDay.length
              ? nCol < lstDay.length - 1
                  ? nCol
                  : 0
              : nCol != 7
                  ? nCol
                  : 0],
          nPeriod: nRow);
    }
  }
}

// ボトムバータップ
void _onBnbTap(int index) {}

// 授業用のセル
class TimeTableCell extends StatefulWidget {
  TimeTableCell({
    super.key,
    required this.strNmDay,
    required this.nPeriod,
  });
  final String strNmDay;
  final int nPeriod;
  String strIdLecture = '';
  String strNmLecture = '';

  @override
  State<TimeTableCell> createState() => _TimeTableCellState();
}

class _TimeTableCellState extends State<TimeTableCell> {
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < tblTimeTable.length; i++) {
      if (tblTimeTable[i]['NM_DAY'].toString() == widget.strNmDay &&
          int.parse(tblTimeTable[i]['N_PERIOD']) == widget.nPeriod) {
        widget.strIdLecture = tblTimeTable[i]['ID_LECTURE'];
        widget.strNmLecture = tblTimeTable[i]['NM_LECTURE'];
        break;
      }
    }
    return InkWell(
        onTap: () {
          selectLesson(
              context, widget.strIdLecture, widget.strNmDay, widget.nPeriod);
        },
        child: Container(
            height: nHeightCell,
            width: nWidthCell,
            decoration: BoxDecoration(
                border: Border.all(width: nWidth, color: colorItem)),
            child: Column(
              children: [
                Text(widget.strNmLecture),
              ],
            )));
  }
}
