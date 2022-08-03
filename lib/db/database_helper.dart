import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DbHelper {
  static Future<Database> database(String dbName) async {
    final dbpath = await sql.getDatabasesPath();

    return sql.openDatabase(path.join(dbpath, '$dbName.db'), version: 1,
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE $dbName(id INTEGER PRIMARY KEY, productId INTEGER, title TEXT NOT NULL, price INTEGER, discountPrice INTEGER, ${dbName == 'cart' ? 'campaignPercentage REAL,' : ''}  ${dbName == 'cart' ? 'quantity INTEGER,' : ''} imgUrl TEXT)');
    });
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DbHelper.database(table);
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> fetchDb(String table) async {
    final db = await DbHelper.database(table);

    return db.query(table);
  }

  static Future<void> updateQuantity(
      String table, int productId, Map<String, dynamic> data) async {
    final db = await DbHelper.database(table);
    db.update(
      table,
      data,
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  static Future<void> deleteDbTable(String table) async {
    final db = await DbHelper.database(table);
    db.delete(table);
  }

  static Future<void> deleteDbSI(String table, int id) async {
    final db = await DbHelper.database(table);

    db.delete(
      table,
      where: 'productId = ?',
      whereArgs: [id],
    );
  }
}
