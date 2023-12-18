import 'package:flutter/material.dart';

// 定数
// 日曜日
const strSunday = 'Sunday';
// 月曜日
const strMonday = 'Monday';
// 火曜日
const strTuesday = 'Tuesday';
// 水曜日
const strWednesday = 'Wednesday';
// 木曜日
const strThursday = 'Thursday';
// 金曜日
const strFriday = 'Friday';
// 土曜日
const strSaturday = 'Saturday';
// 曜日
const lstCdDay = [
  strSunday,
  strMonday,
  strTuesday,
  strWednesday,
  strThursday,
  strFriday,
  strSaturday
];
// 曜日
const lstDay = ['日', '月', '火', '水', '木', '金', '土'];
// 学期
const lstSemestar = ['前期', '後期'];

// 自作Widget
// コンボボックス
class CmbBase extends StatefulWidget {
  const CmbBase(
      {super.key,
      this.firstIndex = 0,
      required this.list,
      required this.color});
  final List<String> list;
  final Color color;
  final int firstIndex;

  @override
  State<CmbBase> createState() => _CmbBaseState();
}

class _CmbBaseState extends State<CmbBase> {
  String dropdownValue = "";
  @override
  Widget build(BuildContext context) {
    if (dropdownValue == "") {
      dropdownValue = widget.list[widget.firstIndex];
    }
    const fontColor = Colors.black;

    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: fontColor,
      ),
      elevation: 2,
      style: const TextStyle(color: fontColor, fontSize: 20),
      underline: Container(
        height: 2,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: widget.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
