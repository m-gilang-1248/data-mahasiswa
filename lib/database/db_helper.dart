// ignore_for_file: non_constant_identifier_namas


//dbhelper ini dibuat untuk
//membuat database, membuat tabel, proses insert, read, update dan delete


import 'package:datamahasiswa/model/data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  //inisialisasi beberapa variabel yang dibutuhkan
  final String tableNama = 'tabeldata';
  final String columnId = 'id';
  final String columnNama = 'nama';
  final String columnNim = 'nim';
  final String columnNohp = 'nohp';
  final String columnAlamat = 'alamat';
  final String columnImageBytes = 'imageBytes';

  DbHelper._internal();
  factory DbHelper() => _instance;

  //cek apakah database ada
  Future<Database?> get _db  async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDb();
    return _database;
  }

  Future<Database?> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'data.db');

    return await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  //membuat tabel dan field-fieldnya
  Future<void> _onCreate(Database db, int version) async {
     var sql = "CREATE TABLE $tableNama($columnId INTEGER PRIMARY KEY, "
         "$columnNama TEXT,"
         "$columnNim TEXT,"
         "$columnNohp TEXT,"
         "$columnAlamat TEXT,"
         "$columnImageBytes BLOB)";
     await db.execute(sql);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    // Lakukan migrasi atau perubahan struktur tabel
    await db.execute('ALTER TABLE $tableNama ADD COLUMN $columnImageBytes BLOB');
  }
  // Implementasikan logika migrasi untuk versi lain jika diperlukan
}


  //insert ke database
  Future<int?> saveDataWithImage(Data data) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableNama, data.toMapWithImage());
  }


  //read database
  Future<List?> getAllDataWithImage() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableNama, columns: [
      columnId,
      columnNama,
      columnNim,
      columnNohp,
      columnAlamat,
      columnImageBytes
    ]);
    return result.toList();
  }


  //update database
  Future<int?> updateDataWithImage(Data data) async {
    var dbClient = await _db;
    return await dbClient!.update(tableNama, data.toMapWithImage(), where: '$columnId = ?', whereArgs: [data.id]);
  }


  //hapus database
  Future<int?> deleteDataWithImage(int id) async {
    var dbClient = await _db;
    return await dbClient!.delete(tableNama, where: '$columnId = ?', whereArgs: [id]);
  }
}