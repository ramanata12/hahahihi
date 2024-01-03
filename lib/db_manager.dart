/// db_manager.dart
///
/// File ini berisi implementasi kelas DatabaseHelper yang bertanggung jawab untuk
/// mengelola database SQLite untuk kategori dan kontak.

import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

/// Kelas DatabaseHelper digunakan untuk mengelola database SQLite untuk kategori dan kontak.
class DatabaseHelper {
  /// Nama database.
  static final _databaseName = "MyDatabase.db";

  /// Versi database.
  static final _databaseVersion = 1;

  /// Nama tabel untuk kategori.
  static final table = 'category';

  /// Nama tabel untuk kontak.
  static final tableContact = 'contact';

  /// Kolom ID.
  static final columnId = '_id';

  /// Kolom nama.
  static final columnName = 'name';

  /// Kolom nama belakang.
  static final columnLName = 'lname';

  /// Kolom nomor telepon.
  static final columnMobile = 'mobile';

  /// Kolom alamat email.
  static final columnEmail = 'email';

  /// Kolom kategori.
  static final columnCategory = 'cat';

  /// Kolom foto profil dalam bentuk base64.
  static final columnProfile = 'profile';

  // Membuat kelas ini sebagai singleton.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Hanya memiliki satu referensi database di seluruh aplikasi.
  static Database? _database;

  /// Getter untuk mendapatkan database.
  Future<Database> get database async => _database ??= await _initDatabase();

  /// Getter untuk mendapatkan database dan memberikan null jika tidak ada.
  Future<Database?> get database1 async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database;
  }

  // Metode untuk membuka database (dan membuatnya jika tidak ada).
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Query SQL untuk membuat tabel kategori dan tabel kontak.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL 
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableContact (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL, 
            $columnLName TEXT NOT NULL, 
            $columnMobile TEXT NOT NULL, 
            $columnEmail TEXT NOT NULL, 
            $columnCategory TEXT NOT NULL, 
            $columnProfile TEXT NOT NULL
          )
          ''');
  }

  // Metode utilitas untuk menambahkan baris ke tabel kategori.
  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db.insert(table, row);
  }

  // Metode utilitas untuk menambahkan baris ke tabel kontak.
  Future<int> insertContact(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db.insert(tableContact, row);
  }

  // Metode utilitas untuk mengambil semua baris dari tabel kategori.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Metode utilitas untuk mengambil semua baris dari tabel kontak.
  Future<List<Map<String, dynamic>>> queryAllRowsofContact() async {
    Database db = await instance.database;
    return await db.query(tableContact);
  }

  // Metode utilitas untuk menghitung jumlah baris dalam tabel kategori.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM $table')) ??
        0;
  }

  // Metode utilitas untuk mengupdate baris dalam tabel kategori.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Metode utilitas untuk menghapus baris dalam tabel kategori berdasarkan ID.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // Metode utilitas untuk menghapus baris dalam tabel kontak berdasarkan ID.
  Future<int> deleteContact(int id) async {
    Database db = await instance.database;
    return await db
        .delete(tableContact, where: '$columnId = ?', whereArgs: [id]);
  }
}
