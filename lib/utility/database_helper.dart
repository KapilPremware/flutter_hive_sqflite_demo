import 'package:flutter_hive_demo/model/news_post.dart';
import 'package:flutter_hive_demo/model/api_data_class.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singleton DatabaseHelper
  static Database _database; //Singleton DatabaseHelper
  APIDataClass resData;

  //===================  Basic Query Example  =========================
  //var result = await db.rawQuery('Select * from $noteTable order by $Name ASC');
  //var result = await db.rawQuery('Select * from $noteTable order by $Name ASC');

  //========================  DATABASE  CREATION  ================================

  String dbName = "myDB.db";
  String tblNewsPost = "NewsPost";
  String tblCounter = "Counter";

  DatabaseHelper._createInstance(); //Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper =
          DatabaseHelper._createInstance(); //this is executed only once
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async {
    //Get the default path of both android & ios to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + dbName;

    //open/create database at given path
    var database = await openDatabase(path, version: 1, onCreate: _createDb);
    return database;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tblNewsPost(postId TEXT, userId TEXT, count REAL)');
  }

  //========================  Database  CRUD  OPERATIONS  ================================

  //Common Query For all
  Future<APIDataClass> getData(String table) async {
    try {
      Database db = await this.database;
      var result = await db.query(table);
      resData = APIDataClass(
        Message: "Success",
        IsSuccess: true,
        Data: result,
      );
      return resData;
    } on Exception catch (e) {
      resData = APIDataClass(
        Message: e.toString(),
        IsSuccess: false,
        Data: [],
      );
      return resData;
    }
  }

  Future<APIDataClass> getDataWithCondition(
      String table, String where, List<dynamic> whereArgs) async {
    try {
      Database db = await this.database;
      var result = await db.query(table, where: where, whereArgs: whereArgs);
      resData = APIDataClass(
        Message: "Success",
        IsSuccess: true,
        Data: result,
      );
      return resData;
    } on Exception catch (e) {
      resData = APIDataClass(
        Message: e.toString(),
        IsSuccess: false,
        Data: [],
      );
      return resData;
    }
  }

  Future<APIDataClass> insert(String table, NewsPost newsPost) async {
    try {
      Database db = await this.database;
      await db.insert(table, newsPost.toMap());
      resData = APIDataClass(
        Message: "Success",
        IsSuccess: true,
        Data: 1,
      );
      return resData;
    } on Exception catch (e) {
      resData = APIDataClass(
        Message: e.toString(),
        IsSuccess: false,
        Data: 0,
      );
      return resData;
    }
  }

  Future<APIDataClass> insertBulk(List<NewsPost> newsPostList) async {
    try {
      Database db = await this.database;
      for (int i = 0; i < newsPostList.length; i++) {
        await db.insert(tblNewsPost, newsPostList[i].toMap());
      }
      resData = APIDataClass(
        Message: "Success",
        IsSuccess: true,
        Data: 1,
      );
      return resData;
    } on Exception catch (e) {
      resData = APIDataClass(
        Message: e.toString(),
        IsSuccess: false,
        Data: 0,
      );
      return resData;
    }
  }

  Future<APIDataClass> update(String table, String where,
      List<dynamic> whereArgs, NewsPost newsPost) async {
    try {
      Database db = await this.database;
      await db.update(tblNewsPost, newsPost.toMap(),
          where: where, whereArgs: whereArgs);
      resData = APIDataClass(
        Message: "Success",
        IsSuccess: true,
        Data: 1,
      );
      return resData;
    } on Exception catch (e) {
      resData = APIDataClass(
        Message: e.toString(),
        IsSuccess: false,
        Data: 0,
      );
      return resData;
    }
  }

  Future<APIDataClass> delete(String userId, String postId) async {
    try {
      Database db = await this.database;
      await db.rawDelete(
          'Delete from $tblNewsPost where userId = $userId & postId = $postId');
      resData = APIDataClass(
        Message: "Success",
        IsSuccess: true,
        Data: 1,
      );
      return resData;
    } on Exception catch (e) {
      resData = APIDataClass(
        Message: e.toString(),
        IsSuccess: false,
        Data: 0,
      );
      return resData;
    }
  }

  //Raw Query Start

  Future<APIDataClass> getDataRaw(String query) async {
    try {
      Database db = await this.database;
      var result = await db.rawQuery(query);
      resData = APIDataClass(
        Message: "Success",
        IsSuccess: true,
        Data: result,
      );
      return resData;
    } on Exception catch (e) {
      resData = APIDataClass(
        Message: e.toString(),
        IsSuccess: false,
        Data: [],
      );
      return resData;
    }
  }

  Future<APIDataClass> insertRaw(String query, List<dynamic> arguments) async {
    try {
      Database db = await this.database;
      await db.rawInsert(query, arguments);
      resData = APIDataClass(
        Message: "Success",
        IsSuccess: true,
        Data: 1,
      );
      return resData;
    } on Exception catch (e) {
      resData = APIDataClass(
        Message: e.toString(),
        IsSuccess: false,
        Data: 0,
      );
      return resData;
    }
  }

  Future<APIDataClass> updateRaw(String query, List<dynamic> arguments) async {
    try {
      Database db = await this.database;
      await db.rawUpdate(query, arguments);
      resData = APIDataClass(
        Message: "Success",
        IsSuccess: true,
        Data: 1,
      );
      return resData;
    } on Exception catch (e) {
      resData = APIDataClass(
        Message: e.toString(),
        IsSuccess: false,
        Data: 0,
      );
      return resData;
    }
  }

  Future<APIDataClass> deleteRaw(String query, List<dynamic> arguments) async {
    try {
      Database db = await this.database;
      await db.rawDelete(query, arguments);
      resData = APIDataClass(
        Message: "Success",
        IsSuccess: true,
        Data: 1,
      );
      return resData;
    } on Exception catch (e) {
      resData = APIDataClass(
        Message: e.toString(),
        IsSuccess: false,
        Data: 0,
      );
      return resData;
    }
  }

  //Raw Query End

  //Other Ways

  /*Future<List<Map<String, dynamic>>> getNewsPostMapList() async {
    try {
      Database db = await this.database;
      var result = await db.query(tblNewsPost);
      return result;
    } on Exception catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getNewsByWhereCondition(
      String userId, String postId) async {
    try {
      Database db = await this.database;
      var result = await db.query(tblNewsPost,
          where: 'userId = ? & postId = ?', whereArgs: [userId, postId]);
      return result;
    } on Exception catch (e) {
      return [];
    }
  }

  //Insert Operation
  Future<int> insertNewsPost(NewsPost newsPost) async {
    try {
      Database db = await this.database;
      await db.insert(tblNewsPost, newsPost.toMap());
      return 1;
    } on Exception catch (e) {
      return 0;
    }
  }

  Future<int> insertBulkNewsPost(List<NewsPost> newsPostList) async {
    try {
      Database db = await this.database;
      for (int i = 0; i < newsPostList.length; i++) {
        await db.insert(tblNewsPost, newsPostList[i].toMap());
      }
      return 1;
    } on Exception catch (e) {
      return 0;
    }
  }

  //Update Operation
  Future<int> updateNewsPost(NewsPost newsPost) async {
    try {
      Database db = await this.database;
      await db.update(tblNewsPost, newsPost.toMap(),
          where: 'userId = ? & postId = ?',
          whereArgs: [newsPost.userId, newsPost.postId]);
      return 1;
    } on Exception catch (e) {
      return 0;
    }
  }

  //Delete Operation
  Future<int> deleteNewsPost(String userId, String postId) async {
    try {
      Database db = await this.database;
      await db.rawDelete(
          'Delete from $tblNewsPost where userId = $userId & postId = $postId');
      return 1;
    } on Exception catch (e) {
      return 0;
    }
  }*/
}
