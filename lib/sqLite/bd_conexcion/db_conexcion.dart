import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqllite/sqLite/bd_table_base/table_base.dart';

class ConexionBD {
  static const String databaseName = "DiaryApp";
  static const int databaseVersion = 1;

  Future<Database> openBD() async {
    try {
      String path = join(await getDatabasesPath(), databaseName);
      Database db = await openDatabase(path,
          version: databaseVersion,
          onConfigure: onConfigure,
          onCreate: onCreate);

      await onConfigure(db);
      await onCreate(db, databaseVersion);

      return db;
    } catch (e) {
      print("Error al abrir la base de datos: $e");
      rethrow;
    }
  }

  Future<void> onConfigure(Database db) async {
    try {
      await db.execute('PRAGMA foreign_keys = ON');
    } catch (e) {
      print("Error al configurar la base de datos: $e");
    }
  }

  Future<void> onCreate(Database db, int version) async {
    try {
      for (var script in modelsTable) {
        await db.execute(script);
      }
    } catch (e) {
      print("Error al crear la tabla: $e");
    }
  }
}
