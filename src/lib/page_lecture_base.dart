import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'validators.dart';
import 'db_helper.dart';
import 'package:flutter/material.dart';
import 'base_component.dart';
import 'time_table.dart';

//授業・単位数登録画面
abstract class PageLectureBase extends StatelessWidget {
  final int nBaseSchoolYear;
  final String strBaseClsSemestar;

  int get schoolYear => nBaseSchoolYear;
  String get clsSemestar => strBaseClsSemestar;

  @override
  PageLectureBase(
      {super.key,
      required this.nBaseSchoolYear,
      required this.strBaseClsSemestar});
  // 授業登録
  Future<int> insertLecture(DatabaseHelper db, DataLecture data) {
    return db.insertLectureData(data);
  }

  // 授業区分登録
  void insertDivLecture(DatabaseHelper db, DataDiv data) async {
    db.insertDivLectureData(data);
  }

  // 出席登録
  void insertAttendance(DatabaseHelper db, DataAttendance data) async {
    db.insertAttendanceData(data);
  }

  // リレーション登録
  void insertRel(DatabaseHelper db, DataRel data) async {
    db.intsertDivLectureRel(data);
  }

  // 時間割登録
  Future<void> insertSchedule(DatabaseHelper db, DataSchedule data) async {
    db.insertScheduleData(data);
  }

  static String strPageTitle = '';

  static final TextEditingController _jugyouController =
      TextEditingController();
  static final TextEditingController _koushiController =
      TextEditingController();
  static final TextEditingController _kyoushituController =
      TextEditingController();
  static final TextEditingController _memoController = TextEditingController();
  String selectedUnit = '';

  String get nmLecture => _jugyouController.text;
  String get nmTeacher => _koushiController.text;
  String get nmClassRoom => _kyoushituController.text;
  String get strMemo => _memoController.text;

  bool _bEditable = false;
  set editable(bool b) {
    _bEditable = b;
  }

  // 各画面専用widget
  Widget individualWidget();

  // ページタイトル設定
  void setPageTitle(String strTitle) {
    strPageTitle = strTitle;
  }

  // 登録・更新
  void insOrUpd();

  //各画面専用wigetをクリア
  void clearIndividual();

  @override
  Widget build(BuildContext context) {
    const key = GlobalObjectKey<FormState>('FORM_KEY');
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              _jugyouController.clear();
              _koushiController.clear();
              _kyoushituController.clear();
              _memoController.clear();
              clearIndividual();
              Future.delayed(Duration.zero, () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const TimeTable()));
              });
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text(strPageTitle),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: key,
                  child: IgnorePointer(
                    ignoring: _bEditable,
                    child: Column(children: [
                      TextFormField(
                        controller: _jugyouController,
                        validator: nameValidator,
                        decoration: const InputDecoration(
                          labelText: '授業名',
                        ),
                      ),
                      // SizedBox(height: 16.0),
                      TextField(
                        controller: _koushiController,
                        decoration: const InputDecoration(
                          labelText: '講師名',
                        ),
                      ),
                      //  SizedBox(height: 16.0),
                      TextField(
                        controller: _kyoushituController,
                        decoration: const InputDecoration(
                          labelText: '教室',
                        ),
                      ),
                      //  SizedBox(height: 16.0),
                      Row(children: [
                        const Text('単位数'),
                        CmbBase(
                          list: const <String>['', '1', '2', '3', '4'],
                          onSelect: (String? str) {
                            selectedUnit = str.toString();
                          },
                        ),
                      ]),
                      individualWidget(),
                      //  SizedBox(height: 16.0),
                      TextField(
                        controller: _memoController,
                        decoration: const InputDecoration(
                            labelText: 'メモ', hintText: '\n\n\n'),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      // SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            if (!_bEditable) {
                              _bEditable = true;
                              insOrUpd();
                              Future.delayed(Duration.zero, () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TimeTable()));
                              });
                            }
                          }
                        },
                        child: Text(_bEditable ? '編集' : '登録'),
                      ),
                    ]),
                  ),
                ),
              ),
            )));
  }
}
