import 'package:flutter/material.dart';

// 定数
// 日曜日
const strSunday = '日';
// 月曜日
const strMonday = '月';
// 火曜日
const strTuesday = '火';
// 水曜日
const strWednesday = '水';
// 木曜日
const strThursday = '木';
// 金曜日
const strFriday = '金';
// 土曜日
const strSaturday = '土';
// 曜日
const lstDay = [
  strSunday,
  strMonday,
  strTuesday,
  strWednesday,
  strThursday,
  strFriday,
  strSaturday
];
// 学期
const lstSemestar = ['前期', '後期'];

// 自作Widget
// コンボボックス
class CmbBase extends StatefulWidget {
  const CmbBase(
      {super.key,
      this.firstIndex = 0,
      required this.list,
      required this.color,
      required this.onSelect});
  final List<String> list;
  final Color color;
  final int firstIndex;
  final Function(String?) onSelect;
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
        widget.onSelect(value);
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
