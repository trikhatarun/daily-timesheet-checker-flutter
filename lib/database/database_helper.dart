import 'dart:collection';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'model/user.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String tableName = 'users';
  static String colId = 'id';
  static String colEmail = 'email';
  static String colName = 'name';
  static String colSlackId = 'slackId';
  static String colCompleted = 'completed';
  static String colDev = 'dev';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if(_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'timesheet.db';

    var tickDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return tickDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableName($colId INTEGER PRIMARY KEY, $colName TEXT, $colEmail TEXT, $colSlackId TEXT, $colCompleted INTEGER, $colDev INTEGER)');
  }

  Future<List<Map<String, dynamic>>>getUsersMapList() async {
    Database db = await this.database;
    
    var result = await db.query(tableName, orderBy: '$colName ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>>getDevUsersMapList() async {
    Database db = await this.database;

    var result = await db.query(tableName, where: '$colDev == 1', orderBy: '$colName ASC');
    return result;
  }

  void insertUsers(List<User> userList) async {
    Database db = await this.database;

    Batch batch = db.batch();
    userList.forEach((user) {
      batch.insert(tableName, user.toMap());
    });

    await batch.commit(continueOnError: true, noResult: true);
  }

  Future<int> updateUser(User user) async {
    Database db = await this.database;

    int id = user.id;
    var result = await db.update(tableName, user.toMap(), where: '$colId == $id');
    return result;
  }

  Future<List<User>> getUsersList() async {
    List<Map<String, dynamic>> mapList = await getUsersMapList();

    List<User> userList = List<User>();

    mapList.forEach((userMap) {
      userList.add(User.fromMap(userMap));
    });

    return userList;
  }

  Future<List<User>> getDevsList() async {
    List<Map<String, dynamic>> mapList = await getDevUsersMapList();

    List<User> userList = List<User>();

    mapList.forEach((userMap) {
      userList.add(User.fromMap(userMap));
    });

    return userList;
  }
}
