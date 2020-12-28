import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

//only need for restore
//import 'package:file_picker/file_picker.dart';

class HiveHelper {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> tableList = [
    "likeBox",
    "shareBox",
    "taskBox",
  ];

  List<Box> _database = [];

  //making it a singleton class
  HiveHelper._privateConstructor();

  static final HiveHelper instance = HiveHelper._privateConstructor();

  //check for db if not found go to create new db
  Future<List<Box>> get database async {
    if (_database != null && _database.length > 0) return _database;

    _database = await _initiateDatabase();
    return _database;
  }

  //create new db
  _initiateDatabase() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    for (int i = 0; i < tableList.length; i++) {
      var box = await Hive.openBox(tableList[i]);
      _database.add(box);
    }
    return _database;
  }

  //backup db
  /*Future<void> createBackup() async {
    if (_database.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text('DB is empty')),
      );
      return;
    }
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text('Creating backup...')),
    );
    Map<String, String> map = _database.toMap().map((key, value) => MapEntry(key.toString(), value));
    String json = jsonEncode(map);
    Directory dir = await _getDirectory();
    String formattedDate = DateTime.now()
        .toString()
        .replaceAll('.', '-')
        .replaceAll(' ', '-')
        .replaceAll(':', '-');
    String path = '${dir.path}$formattedDate.hivebackup';
    File backupFile = File(path);
    await backupFile.writeAsString(json);
  }*/

  //directory
  Future<Directory> _getDirectory() async {
    Directory directory = await getExternalStorageDirectory();
    const String pathExt = '/backups/';
    Directory newDirectory = Directory(directory.path + pathExt);
    if (await newDirectory.exists() == false) {
      return newDirectory.create(recursive: true);
    }
    return newDirectory;
  }

  //restore db
  /*Future<void> restoreBackup() async {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text('Restoring backup...')),
    );
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File file = File(result.files.single.path);
      _database.clear();
      Map<dynamic, dynamic> map =
      jsonDecode(await file.readAsString()) as Map<dynamic, dynamic>;
      Map<int, String> newMap =
      map.map<int, String>((key, value) => MapEntry(int.parse(key), value));
      _database.putAll(newMap);
    } else {
      SnackBar(content: Text('User canceled the picker'));
    }
  }*/

  //get box
  Future<Box> dbBox(String tableName) async {
    try {
      List<Box> dbList = await instance.database;
      int index = tableList.indexOf(tableName);
      return dbList[index];
    } on Exception catch (e) {
      return null;
    }
  }

  //put data
  Future<int> dbPut(dynamic key, dynamic value, String tableName) async {
    try {
      //database list
      List<Box> dbList = await instance.database;
      //index of table
      int index = tableList.indexOf(tableName);
      //save data to table
      await dbList[index].put(key, value);
      return 1;
    } on Exception catch (e) {
      return 0;
    }
  }

  //get Put data
  Future<dynamic> dbGetPut(dynamic key, String tableName) async {
    try {
      //database list
      List<Box> dbList = await instance.database;
      //index of table
      int index = tableList.indexOf(tableName);
      //get data from table
      var res = await dbList[index].get(key);
      return res;
    } on Exception catch (e) {
      return 0;
    }
  }

  //add data as object
  Future<int> dbAddObject(dynamic value, String tableName) async {
    try {
      List<Box> dbList = await instance.database;
      int index = tableList.indexOf(tableName);
      await dbList[index].add(value);
      return 1;
    } on Exception catch (e) {
      return 0;
    }
  }

  //get data as object list
  Future<List> dbGetObject(String tableName) async {
    try {
      List dataList = [];
      var res = Hive.box(tableName);
      if (res != null && res.length > 0) {
        for (int i = 0; i < res.length; i++) {
          var data = res.get(i) as dynamic;
          dataList.add(data);
        }
      }

      return dataList;
    } on Exception catch (e) {
      return [];
    }
  }
}
