import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), "freesh.db");

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: (db, version) async {

        await db.execute('''
          CREATE TABLE category(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            createdAt TEXT,
            type TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE vegetable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            quantity INTEGER,
            imageName TEXT,
            notes TEXT,
            purchaseDate TEXT,
            shelfLifeDays INTEGER,
            status TEXT,
            categoryId INTEGER,
            type TEXT,
            FOREIGN KEY (categoryId) REFERENCES category(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // CATEGORY
  Future<int> insertCategory(String name, String type) async {
    final dbClient = await db;
    return await dbClient.insert("category", {
      "name": name,
      "type": type,
      "createdAt": DateTime.now().toString()
    });
  }

  Future<List<Map<String, dynamic>>> getCategoriesByType(String type) async {
    final dbClient = await db;
    return dbClient.query("category",
        where: "type=?", whereArgs: [type]);
  }

  Future<int> deleteCategory(int id) async {
    final dbClient = await db;
    return dbClient.delete("category", where: "id=?", whereArgs: [id]);
  }

  // ITEMS
  Future<int> insertVegetable(Map<String, dynamic> data, String type) async {
    final dbClient = await db;
    data["type"] = type;
    return dbClient.insert("vegetable", data);
  }

  Future<List<Map<String, dynamic>>> getVegetablesByType(String type) async {
    final dbClient = await db;
    return await dbClient.rawQuery('''
      SELECT v.*, c.name AS categoryName
      FROM vegetable v
      LEFT JOIN category c ON v.categoryId = c.id
      WHERE v.type = ?
    ''', [type]);
  }

  Future<List<Map<String, dynamic>>> getVegetablesByCategory(int id) async {
    final dbClient = await db;
    return dbClient.query("vegetable",
        where: "categoryId=?", whereArgs: [id]);
  }

  Future<int> deleteVegetable(int id) async {
    final dbClient = await db;
    return dbClient.delete("vegetable", where: "id=?", whereArgs: [id]);
  }

  Future<int> getExpiredCount(String type, int days) async {
    final dbClient = await db;

    DateTime now = DateTime.now();
    DateTime past = now.subtract(Duration(days: days));

    List data = await dbClient.query("vegetable",
        where: "type=? AND status=?",
        whereArgs: [type, "expired"]);

    return data.where((v) {
      DateTime d = DateTime.parse(v['purchaseDate']);
      return d.isAfter(past);
    }).length;
  }


}