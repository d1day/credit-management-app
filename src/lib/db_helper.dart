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
          CREATE TABLE M_LECTURE (
            ID_LECTURE INTEGER PRIMARY KEY AUTOINCREMENT,
            NM_LECTURE TEXT,
            CLS_OPEN_CLASS TEXT,
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
            FOREIGN KEY (ID_LECTURE) references M_LECTURE(ID_LECTURE)
          )
        ''');
        await db.execute('''
          CREATE TABLE M_DIV_LECTURE_REL(
            ID_DIV_LECTURTE INTEGER AUTOINCREMENT,
            ID_LECTURE INTEGER,
            PRIMARY KEY (ID_DIV_LECTURTE, ID_LECTURE),
            FOREIGN KEY (ID_LECTURE) references M_LECTURE(ID_LECTURE)
          )
        ''');
        await db.execute('''
          CREATE TABLE M_DIV_LECTURE(
            ID_DIV_LECTURE INTEGER PRIMARY KEY,
            NM_DIV_LECTURE TEXT
          )
          ''');
        await db.execute('''
          CREATE TABLE T_ATTENDANCE(
            ID_LECTURE INTEGER PRIMARY KEY AUTOINCREMENT,
            N_ATTENDANCE INTEGER,
            N_ABSENCE INTEGER,
            N_BEHIND INTEGER,
            N_OFFICIAL_ABSENCE INTEGER,
            FOREIGN KEY (ID_LECTURE) references M_LECTURE(ID_LECTURE)
          )
        ''');
      },
    );
    return database;
  }

  Future<int> insertLectureData(DataLecture data) async {
    final db = await initializeDatabase();
    await db.insert('M_LECTURE', {
      'ID_LECTURE': data.nIdLecture,
      'NM_LECTURE': data.strNmLecture,
      'CLS_OPEN_CLASS': data.strClsOpenClass,
      'NM_TEACHER': data.strNmTeacher,
      'NM_CLASS_ROOM': data.strNmClassRoom,
      'N_CREDIT': data.nCredit,
      'CLS_STATUS': data.strClsStatus,
      'CLS_COLOR': data.strClsColor,
      'TXT_FREE': data.strTxtFree,
    });
    int nIdLecture = 0;
    await db
        .rawQuery(
            'select ID_LECTURE from M_LECTURE order by ID_LECTURE desc limit 1')
        .then((value) => nIdLecture = int.parse(value[0].toString()));
    return nIdLecture;
  }

  Future<void> insertScheduleData(DataSchedule data) async {
    final db = await initializeDatabase();
    await db.insert('M_SCHEDULE', {
      'N_SCHOOL_YEAR': data.nSchoolYear,
      'CLS_SEMESTER': data.strClsSemester,
      'NM_DAY': data.strClsSemester,
      'N_PERIOD': data.nPeriod,
      'ID_LECTURE': data.nIdLecture
    });
  }

  Future<void> insertDivLectureData(DataDiv data) async {
    final db = await initializeDatabase();
    await db.insert('M_DIV_LECTURE', {
      'ID_DIV_LECTURE': data.nIdDivLecture,
      'NM_DIV_LECTURE': data.strNmDivLecture
    });
  }

  Future<void> intsertDivLectureRel(DataRel data) async {
    final db = await initializeDatabase();
    await db.insert('M_DIV_LECTURE_REL',
        {'ID_LECTURE': data.nIdLecture, 'ID_DIV_LECTURE': data.nIdDevLecture});
  }

  Future<void> insertAttendanceData(DataAttendance data) async {
    final db = await initializeDatabase();
    await db.insert('M_ATTENCANCE', {
      'ID_LECTURE': data.nIdLecture,
      'N_ATTENDANCE': data.nAttendance,
      'N_ABSENCE': data.nAbsence,
      'N_BEHIND': data.nBehind,
      'N_OFFICIAL_ABSENCE': data.nOfficialAbsence
    });
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
        INNER JOIN M_LECTURE l ON
          s.ID_LECTURE = l.ID_LECTURE
        WHERE
          s.N_SCHOOL_YEAR = ${XDb.sqlEscape(nYear.toString())} and
          s.CLS_SEMESTER = '${XDb.sqlEscape(strClsSemestar)}'
      ''');
    return Future<List<Map>>.value(result);
  }
}

class DataLecture {
  final int? nIdLecture;
  final String? strNmLecture;
  final String? strClsOpenClass;
  final String? strNmTeacher;
  final String? strNmClassRoom;
  final int? nCredit;
  final String? strClsStatus;
  final String? strClsColor;
  final String? strTxtFree;
  DataLecture(
      this.nIdLecture,
      this.strNmLecture,
      this.strClsOpenClass,
      this.strNmTeacher,
      this.strNmClassRoom,
      this.nCredit,
      this.strClsStatus,
      this.strClsColor,
      this.strTxtFree);
}

class DataSchedule {
  final int? nSchoolYear;
  final String? strClsSemester;
  final String? strNmDay;
  final int? nPeriod;
  final int? nIdLecture;
  DataSchedule(this.nSchoolYear, this.strClsSemester, this.strNmDay,
      this.nPeriod, this.nIdLecture);
}

class DataDiv {
  final int nIdDivLecture;
  final String strNmDivLecture;
  DataDiv(this.nIdDivLecture, this.strNmDivLecture);
}

class DataRel {
  final int nIdDevLecture;
  final int nIdLecture;
  DataRel(this.nIdDevLecture, this.nIdLecture);
}

class DataAttendance {
  final int nIdLecture;
  final int nAttendance;
  final int nAbsence;
  final int nBehind;
  final int nOfficialAbsence;
  DataAttendance(this.nIdLecture, this.nAttendance, this.nAbsence, this.nBehind,
      this.nOfficialAbsence);
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
