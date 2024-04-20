import 'package:flutter/material.dart';
import 'db_helper.dart';

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

//円の色
const List<Color> lstCirclecolor = [
  Color(0xFFF8BBD4),
  Color(0xFFEF9A9A),
  Color(0xFFFFAB91),
  Color(0xFFAED581),
  Color(0xFF81C784),
  Color(0xFF4DB6AC),
  Color(0xFFFFF59D),
  Color(0xFFCE93D8),
];

// 自作Widget
// コンボボックス
class CmbBase extends StatefulWidget {
  const CmbBase(
      {super.key,
      this.firstIndex = 0,
      required this.list,
      this.color,
      required this.onSelect});
  final List<String> list;
  final Color? color;
  final int firstIndex;
  final Function(String) onSelect;
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelect(dropdownValue);
    });

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
        if (value != null) {
          widget.onSelect(value);
        }
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
