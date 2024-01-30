import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> initializeDatabase() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      // 外部キー制約を有効にする
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE lecturetable (
            ID_LECTURE INTEGER PRIMARY KEY,
            CD_DIV_LECTURTE TEXT,
            NM_LECTURE TEXT,
            FLG_INTENSIVE_COURSE TEXT,
            NM_TEACHER TEXT,
            NM_CLASS_ROOM TEXT,
            N_CREDIT INTEGER,
            CLS_STATUS TEXT,
            CLS_COLOR TEXT,
            TXT_FREE TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE timetable (
            N_SCHOOL_YEAR INTEGER,
            CLS_SEMESTER TEXT,
            NM_DAY TEXT,
            N_PERIOD INTEGER,
            ID_LECTURE INTEGER,
            FOREIGN KEY (ID_LECTURE) references lecturetable(ID_LECTURE))
          )
        ''');
      },
      version: 1,
    );
    return database;
  }

  //登録処理
}

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
