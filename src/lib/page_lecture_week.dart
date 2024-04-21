import 'package:test_project/page_lecture_base.dart';
import 'validators.dart';
import 'db_helper.dart';
import 'package:flutter/material.dart';
import 'base_component.dart';
import 'page_lecture_base.dart';

class LectureWeek extends PageLectureBase {
  final String strNmDay;
  final int nPeriod;
  final int nSchoolYear;
  final String strClsSemester;

  @override
  LectureWeek(
      {super.key,
      required this.nSchoolYear,
      required this.strClsSemester,
      required this.strNmDay,
      required this.nPeriod})
      : super(nBaseSchoolYear: nSchoolYear, strBaseClsSemestar: strClsSemester);

  static int colorUnit = 0;

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  @override
  Widget individualWidget() {
    return Row(children: [
      const Text('カラー'),
      cmbColor,
    ]);
  }

  final cmbColor = const CmbColor();

  @override
  void clearIndividual() {
    colorUnit = 0;
  }

  @override
  void insOrUpd() async {
    String jugyou = super.nmLecture;
    String koushi = super.nmTeacher;
    String kyoushitu = super.nmClassRoom;
    String memo = super.strMemo;
    // 授業
    var lecture =
        DataLecture(0, jugyou, '', koushi, kyoushitu, 0, '', colorUnit, memo);
    DatabaseHelper db = DatabaseHelper();
    int nId = 0;
    await insertLecture(db, lecture).then((value) => nId = value);
    // 時間割
    var schedule =
        DataSchedule(nSchoolYear, strClsSemester, strNmDay, nPeriod, nId);
    await insertSchedule(db, schedule);
  }
}

class CmbColor extends StatefulWidget {
  const CmbColor({super.key});
  @override
  State<CmbColor> createState() => _CmbColorState();
}

class _CmbColorState extends State<CmbColor> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: LectureWeek.colorUnit,
      onChanged: (int? value) {
        setState(() {
          LectureWeek.colorUnit = value!;
        });
      },
      items: lstCirclecolor.asMap().entries.map((entry) {
        int index = entry.key;
        Color color = entry.value;
        return DropdownMenuItem<int>(
          value: index,
          child: Row(
            children: [
              Icon(Icons.circle, color: color),
            ],
          ),
        );
      }).toList(),
    );
  }
}
