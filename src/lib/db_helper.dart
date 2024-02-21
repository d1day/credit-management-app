import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static late Database database;
  static late DatabaseFactory databaseFactory;

  static Future<Database> initializeDatabase() async {
    databaseFactory = databaseFactoryFfi;
    final dbDirectory = await getApplicationSupportDirectory();
    final dbFilePath = dbDirectory.path;
    final path = join(dbFilePath, 'my_database.db');

    database = await openDatabase(
      path,
      version: 1,
      // 外部キー制約を有効にする
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE M_CREDITS (
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
          CREATE TABLE M_SCHEDULE (
            N_SCHOOL_YEAR INTEGER,
            CLS_SEMESTER TEXT,
            NM_DAY TEXT,
            N_PERIOD INTEGER,
            ID_LECTURE INTEGER,
            PRIMARY KEY (N_SCHOOL_YEAR, CLS_SEMESTER, NM_DAY, N_PERIOD),
            FOREIGN KEY (ID_LECTURE) references M_CREDITS(ID_LECTURE)
          )
        ''');
        await db.execute('''
          CREATE TABLE M_DIV_LECTURE(
            CD_DIV_LECTURTE TEXT PRIMARY KEY,
            NM_DIV_LECTURE TEXT,
            ID_LECTURE INTEGER,
            FOREIGN KEY (ID_LECTURE) references M_CREDITS(ID_LECTURE)
          )
        ''');
        await db.execute('''
          CREATE TABLE T_ATTENDANCE(
            ID_LECTURE INTEGER PRIMARY KEY,
            N_ATTENDANCE INTEGER,
            N_ABSENCE INTEGER,
            N_BEHIND INTEGER,
            N_OFFICIAL_ABSENCE INTEGER,
            FOREIGN KEY (ID_LECTURE) references M_CREDITS(ID_LECTURE)
          )
        ''');
      },
    );
    return database;
  }

  Future<int> insertLectureData(Map<String, dynamic> lectureData) async {
    final db = await initializeDatabase();
    return await db.insert('M_CREDITS', lectureData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertSCHEDULEData(int id) async {
    final db = await initializeDatabase();
    await db.insert('M_SCHEDULE', {'ID_LECTURE': id},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertDIVLECTURE(int id) async {
    final db = await initializeDatabase();
    await db.insert('M_DIV_LECTURE', {'ID_LECTURE': id},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertATTENDANCE(int id) async {
    final db = await initializeDatabase();
    await db.insert('T_ATTENDANCE', {'ID_LECTURE': id},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map>> selectTimeTableData(
      int nYear, String strClsSemestar) async {
    final db = await initializeDatabase();
    final result = await db.rawQuery('''
      SELECT
        s.NM_DAY,
        s.N_PERIOD,
        s.ID_LECTURE,
        l.NM_LECTURE,
        l.NM_CLASS_ROOM
      FROM
        M_SCHEDULE s
        INNER JOIN M_CREDITS l ON
          s.ID_LECTURE = l.ID_LECTURE
        WHERE
          s.N_SCHOOL_YEAR = ${XDb.sqlEscape(nYear.toString())} and
          s.CLS_SEMESTER = '${XDb.sqlEscape(strClsSemestar)}'
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
