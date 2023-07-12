import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../data/dateweight_model.dart';



class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'DietAppDB.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE dateWeight(
      date TEXT PRIMARY KEY,
      weight REAL
    )
    ''');
  }

  Future<int> add(DateWeightData chartData) async {
    Database db = await instance.database;
    return await db.insert('dateWeight',
        chartData.toMap());
  }

  Future<List<DateWeightData>> getChartData() async {
    Database db = await instance.database;
    var chartDatas = await db.query('dateWeight', orderBy: 'date');
    List<DateWeightData> chartList = chartDatas.isNotEmpty
        ? chartDatas.map((c) => DateWeightData.fromMap(c)).toList()
        : [];
    return chartList;
  }

  // final db = await instance.database;
  // final result = await db.query('dateWeight');
  // return result.map((row) {
  //   return DateWeightData(
  //     date: DateTime.fromMillisecondsSinceEpoch(row['date'] as int), // Convert the stored integer to DateTime
  //     weight: row['weight'] as double,
  //   );
  // }).toList();

  Future<int> update(DateWeightData chartData) async {
    Database db = await instance.database;
    return await db.update('dateWeight', chartData.toMap(),
        where: 'date = ?', whereArgs: [DateFormat('yyyy-MM-dd').format(chartData.date)]);
  }

  Future<int> remove(DateWeightData chartData) async {
    Database db = await instance.database;
    return await db.delete('dateWeight', where: 'date = ?', whereArgs: [DateFormat('yyyy-MM-dd').format(chartData.date)]);
  }

}