import 'package:flutter/material.dart';

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
