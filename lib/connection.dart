import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'dataconnect.dart';

String table = 'person';

class ConnectionDB {
  Future<Database> initalizeDB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'MyDatabase.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $table(id INTEGER PRIMARY KEY,name TEXT,age TEXT,img TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<List<Person>> getPerson() async {
    final db = await initalizeDB();
    List<Map<String, dynamic>> queryResult = await db.query(table);
    print('Get Person');
    return queryResult.map((e) => Person.fromMap(e)).toList();
  }

  Future<void> insertPerson(Person person) async {
    final db = await initalizeDB();
    await db.insert(table, person.toMap());
    print('Insert Person');
  }

  Future<void> deletePerson(int id) async {
    final db = await initalizeDB();
    await db.delete(table, where: 'id=?', whereArgs: [id]);
  }

  Future<void> updatePerson(Person person) async {
    final db = await initalizeDB();
    await db
        .update(table, person.toMap(), where: 'id=?', whereArgs: [person.id]);
  }
}
