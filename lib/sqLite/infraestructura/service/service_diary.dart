import 'package:sqllite/sqLite/dominio/gateway/gateway_diary.dart';
import 'package:sqllite/sqLite/bd_table_base/table_base.dart';
import 'package:sqllite/sqLite/dominio/models/models_diary.dart';

class ServiceDiary extends DiaryGateway {
  MoDiary moDiary;
  ServiceDiary({required this.moDiary}) : super(diaryTable);

  // Método para convertir un mapa a un objeto ServiceDiary
  MoDiary toObject(Map<String, dynamic> data) {
    return MoDiary(
        id: data['id'], type: data['type'], enterCode: data['enterCode']);
  }

  // Método para convertir un objeto ServiceDiary a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': moDiary.id,
      'type': moDiary.type,
      'enterCode': moDiary.enterCode
    };
  }

  // Método para guardar o actualizar un registro en la base de datos
  Future<int> save() async {
    return await ((moDiary.id <= 0)
        ? create(toMap())
        : update(toMap(), moDiary.id));
  }

  // Método para eliminar un registro de la base de datos
  Future<void> remove() async {
    await delete(moDiary.id);
  }

  // Método para obtener todos los registros de ServiceDiary
  Future<List<MoDiary>> getDiaries() async {
    var result = await rawQuery('SELECT * FROM $diaryTable');
    return _listDiaries(result);
  }

  // Método para convertir los resultados de la consulta en una lista de objetos ServiceDiary
  List<MoDiary> _listDiaries(List<Map<String, dynamic>> parsed) {
    return parsed.map((map) => toObject(map)).toList();
  }
}
