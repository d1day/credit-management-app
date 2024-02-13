import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static late DatabaseFactory databaseFactory;

  static Future<Database> initializeDatabase() async {
    databaseFactory = databaseFactoryFfi;
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
        // await db.execute('''
        // CREATE TABLE timetable (
        // N_SCHOOL_YEAR INTEGER,
        //CLS_SEMESTER TEXT,
        //NM_DAY TEXT,
        //N_PERIOD INTEGER,
        //ID_LECTURE INTEGER,
        //FOREIGN KEY (ID_LECTURE) references lecturetable(ID_LECTURE))
        //)
        //''');
        await db.execute('''
        CREATE TABLE lookuptable(
          CD_LOOKUP_TYPE TEXT,
          CD_LOOKUP TEXT,
          NM_LOOKUP TEXT,
          PRIMARY KEY(CD_LOOKUP_TYPE, CD_LOOKUP, NM_LOOKUP)
        )
        ''');
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertLectureData(Map<String, dynamic> lectureData) async {
    final db = await initializeDatabase();
    await db.insert('lecturetable', lectureData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertTimetableData(Map<String, dynamic> timetableData) async {
    final db = await initializeDatabase();
    await db.insert('timetable', timetableData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map>> selectTimeTableData(
      int nYear, String strClsSemestar) async {
    final db = await initializeDatabase();
    final result = await db.rawQuery('''
      select
        t.nm_day,
        t.n_period,
        t.id_lecture,
        c.nm_lecture
      from
        timetable t
        inner join lecturetable c on
          t.id_lecture = c.id_lecture
        where
          t.n_year = ${XDb.sqlEscape(nYear.toString())} and
          t.cls_semestar = ${XDb.sqlEscape(strClsSemestar)}
      ''');
    return Future<List<Map>>.value(result);
  }
}

//DB関連
class XDb {
  static String sqlEscape(String str) {
    str.replaceAll("'", "''");
    str.replaceAll('"', '""');
    //改行コード？
    return str;
  }

  static String sqlEscapeLike(String str) {
    sqlEscape(str);
    str.replaceAll('%', '');
    str.replaceAll('_', '');
    return str;
  }
}
