import 'validators.dart';
import 'db_helper.dart';
import 'package:flutter/material.dart';
import 'base_component.dart';

// 授業選択時
void selectLesson(
    BuildContext context, String strIdLesson, String strCdDay, int nHour) {
  // 画面遷移時の処理
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => new InsertPage(
        strCdDay: strCdDay,
        nHour: nHour,
      ),
    ),
  );
}

//授業・単位数登録画面
class InsertPage extends StatefulWidget {
  final String strCdDay;
  final int nHour;
  @override
  InsertPage({required this.strCdDay, required this.nHour});
  _InsertPageState createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  final TextEditingController jugyouController = TextEditingController();
  final TextEditingController koushiController = TextEditingController();
  final TextEditingController kyoushituController = TextEditingController();
  String selectedUnit = '';
  String colorUnit = lstCirclecolor.first.toString();
  final TextEditingController memoController = TextEditingController();
  static const key = GlobalObjectKey<FormState>('FORM_KEY');

  @override
  Widget build(BuildContext context) {
    String resultText = widget.strCdDay + widget.nHour.toString();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(resultText),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: key,
          child: Column(children: [
            TextFormField(
              controller: jugyouController,
              validator: nameValidator,
              onChanged: (value) {},
              decoration: InputDecoration(
                labelText: '授業名',
              ),
            ),
            // SizedBox(height: 16.0),
            TextField(
              controller: koushiController,
              onChanged: (value) {},
              decoration: InputDecoration(
                labelText: '講師名',
              ),
            ),
            //  SizedBox(height: 16.0),
            TextField(
              controller: kyoushituController,
              onChanged: (value) {},
              decoration: InputDecoration(
                labelText: '教室',
              ),
            ),
            //  SizedBox(height: 16.0),
            Row(children: [
              Text('単位数'),
              DropdownButton<String>(
                value: selectedUnit,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedUnit = newValue!;
                  });
                },
                items: <String>['', '1', '2', '3', '4']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                //hint: Text('選択してください'),
              ),
            ]),
            //  SizedBox(height: 16.0),
            Row(children: [
              Text('カラー'),
              DropdownButton<String>(
                value: colorUnit,
                onChanged: (String? value) {
                  setState(() {
                    colorUnit = value!;
                  });
                },
                items:
                    lstCirclecolor.map<DropdownMenuItem<String>>((Color value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Icon(
                      Icons.circle,
                      color: value,
                    ),
                  );
                }).toList(),
              ),
            ]),

            //  SizedBox(height: 16.0),
            TextField(
              controller: memoController,
              onChanged: (value) {},
              decoration: InputDecoration(
                labelText: 'メモ',
              ),
            ),
            // SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (key.currentState!.validate()) {
                  _insertData();
                }
              },
              child: Text('データ登録'),
            ),
          ]),
        ),
      ),
    );
  }

  void _insertData() async {
    String jugyou = jugyouController.text;
    String koushi = koushiController.text;
    String kyoushitu = kyoushituController.text;
    String memo = memoController.text;

    if (jugyou.isNotEmpty) {
      DatabaseHelper databaseHelper = DatabaseHelper();

      int insertID = await databaseHelper.insertLectureData({
        'NM_LECTURE': jugyou,
        'NM_TEACHER': koushi,
        'NM_CLASS_ROOM': kyoushitu,
        'N_CREDIT': selectedUnit,
        'CLS_COLOR': colorUnit,
        'TXT_FREE': memo,
      });

      await databaseHelper.insertSCHEDULEData(insertID);

      await databaseHelper.insertDIVLECTURE(insertID);

      await databaseHelper.insertATTENDANCE(insertID);

      print(
          'Data Inserted: $jugyou, $koushi, $kyoushitu, $selectedUnit,$colorUnit,$memo');

      jugyouController.clear();
      koushiController.clear();
      kyoushituController.clear();
      selectedUnit = '';
      memoController.clear();
    } else {}
  }
}
