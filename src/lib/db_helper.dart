import 'package:sqflite/sqflite.dart';

//DB関連
class XDb {
  String sqlEscape(String str) {
    str.replaceAll("'", "''");
    str.replaceAll('"', '""');
    //改行コード？
    return str;
  }

  String sqlEscapeLike(String str) {
    sqlEscape(str);
    str.replaceAll('%', '');
    str.replaceAll('_', '');
    return str;
  }
}
