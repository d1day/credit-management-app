import 'package:flutter/material.dart';
import 'base_component.dart';
import 'page_lecture_week.dart';
import 'db_helper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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

String strYear = '';
String strClsSemestar = '';

// 時間数
final int numPeriod = 6;
// 曜日
final int numDay = 6;

class TimeTable extends StatefulWidget {
  const TimeTable({
    super.key,
  });
  //
  static double nDeviceWidth = 0;
  static double nDeviceHeight = 0;

  //時間割取得
  static Future<List<Map>> getTimeTable(
      String strYear, String strClsSemestar) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    return dbHelper.selectTimeTableData(int.parse(strYear), strClsSemestar);
  }

  // 時間割リスト
  static List<Map> tblTimeTable = List<Map>.empty(growable: true);

  @override
  createState() => _TimeTableState();
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

    //画面サイズから描画するサイズを決定
    final clrAppBarHeight = AppBar().preferredSize.height;
    nWidthPeriod = TimeTable.nDeviceWidth / 14;
    nHeightDay = TimeTable.nDeviceHeight / 20;
    nWidthCell =
        (TimeTable.nDeviceWidth - nWidthPeriod - (nSideSpace * 2)) / numDay;
    nHeightCell = (TimeTable.nDeviceHeight -
                clrAppBarHeight -
                nHeightDay -
                (nTopAndBottomSpace * 2) -
                nBnbHeight) /
            numPeriod -
        5;

    // データ取得
    return FutureBuilder(
        future: TimeTable.getTimeTable(lstYear[10], lstSemestar[0]).then(
          (value) => TimeTable.tblTimeTable = value,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loadingWidget(100);
          } else {
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
                          onSelect: (String str) {
                            strYear = str;
                            TimeTable.getTimeTable(
                                    strYear, strClsSemestar.toString())
                                .then(
                                    (value) => TimeTable.tblTimeTable = value);
                          },
                        ),
                        const Text(
                          '年度 ',
                          style: TextStyle(fontSize: 19),
                        ),
                        CmbBase(
                          list: lstSemestar,
                          color: colorBar,
                          onSelect: (String str) {
                            strClsSemestar = str;
                            TimeTable.getTimeTable(strYear.toString(),
                                    strClsSemestar.toString())
                                .then(
                                    (value) => TimeTable.tblTimeTable = value);
                          },
                        )
                      ]),
                  backgroundColor: colorBar,
                ),
                drawer: Drawer(
                  child: ListView(
                      children: const [ListTile(title: Text('メニュー１'))]),
                ),
                body: Padding(
                    padding: const EdgeInsets.fromLTRB(nSideSpace,
                        nTopAndBottomSpace, nSideSpace, nTopAndBottomSpace),
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
                    child: BottomNavigationBar(
                        items: const <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                              icon:
                                  Icon(Icons.apps_rounded, color: Colors.white),
                              label: '時間割'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.assessment_outlined,
                                  color: Colors.white),
                              label: '単位管理'),
                        ],
                        onTap: _onBnbTap,
                        backgroundColor: colorItem)));
          }
        });
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

  Widget _loadingWidget(double size) {
    return Center(
      child: LoadingAnimationWidget.bouncingBall(
        color: Colors.blue,
        size: size,
      ),
    );
  }
}

// ボトムバータップ
void _onBnbTap(int index) {}

// 授業用のセル
class TimeTableCell extends StatefulWidget {
  const TimeTableCell({
    super.key,
    required this.strNmDay,
    required this.nPeriod,
  });
  final String strNmDay;
  final int nPeriod;

  @override
  State<TimeTableCell> createState() => _TimeTableCellState();
}

class _TimeTableCellState extends State<TimeTableCell> {
  String _strIdLecture = '';
  String _strNmLecture = '';
  String _strNmClassRomm = '';
  Color? _color;
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < TimeTable.tblTimeTable.length; i++) {
      if (TimeTable.tblTimeTable[i]['NM_DAY'].toString() == widget.strNmDay &&
          int.parse(TimeTable.tblTimeTable[i]['N_PERIOD'].toString()) ==
              widget.nPeriod) {
        _strIdLecture = TimeTable.tblTimeTable[i]['ID_LECTURE'].toString();
        _strNmLecture = TimeTable.tblTimeTable[i]['NM_LECTURE'].toString();
        _strNmClassRomm = TimeTable.tblTimeTable[i]['NM_CLASS_ROOM'].toString();
        if (TimeTable.tblTimeTable[i]['CLS_COLOR'] != null) {
          _color = lstCirclecolor[TimeTable.tblTimeTable[i]['CLS_COLOR']];
        }
        break;
      }
    }
    return InkWell(
        onTap: () {
          selectLesson(
              context,
              int.parse(strYear.toString()),
              strClsSemestar.toString(),
              widget.strNmDay,
              widget.nPeriod,
              _strIdLecture);
        },
        child: Container(
            height: nHeightCell,
            width: nWidthCell,
            decoration: BoxDecoration(
                border: Border.all(width: nWidth, color: colorItem),
                color: _color),
            child: Column(
              children: [
                Text(_strNmLecture),
                Text(_strNmClassRomm),
              ],
            )));
  }
}

void selectLesson(BuildContext context, int nSchoolYear, String strClsSemester,
    String strNmDay, int nPeriod, String strIdLesson) {
  // 画面遷移時の処理
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => LectureWeek(
        nSchoolYear: nSchoolYear,
        strClsSemester: strClsSemester,
        strNmDay: strNmDay,
        nPeriod: nPeriod,
      ),
    ),
  );
}
