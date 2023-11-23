import 'package:sqflite/sqflite.dart';
import 'package:sqllite/sqLite/bd_conexcion/db_conexcion.dart';

abstract class DiaryGateway {
  String table;
  DiaryGateway(this.table);

  Future<Database> get database async {
    return await ConexionBD().openBD();
  }

  Future<List<Map<String, Object?>>> rawQuery(String sql,
      {List<dynamic> argumentos = const []}) async {
    return (await database).rawQuery(sql, argumentos);
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    return (await database)
        .update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> create(Map<String, dynamic> date) async {
    return (await database).insert(table, date);
  }

  Future<int> delete(int id) async {
    return (await database).delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
