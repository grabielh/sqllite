// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sqllite/sqLite/dominio/models/models_diary.dart';
import 'package:sqllite/sqLite/infraestructura/service/service_diary.dart';

class CrudDiary extends StatefulWidget {
  const CrudDiary({Key? key}) : super(key: key);

  @override
  State<CrudDiary> createState() => _CrudDiaryState();
}

class _CrudDiaryState extends State<CrudDiary> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _nameDiary = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool visible = true;
  late ServiceDiary serviceDiary;

  @override
  void initState() {
    super.initState();
    serviceDiary =
        ServiceDiary(moDiary: MoDiary(id: 0, userName: '', enterCode: ''));
  }

  void _insertarDatosDiary() async {
    try {
      if (_id.text.isNotEmpty &&
          _nameDiary.text.isNotEmpty &&
          _password.text.isNotEmpty) {
        int id = int.tryParse(_id.text) ?? 0; // Si el parseo falla, se asigna 0
        String name = _nameDiary.text;
        String password = _password.text;
        ServiceDiary serviceDiary = ServiceDiary(
            moDiary: MoDiary(id: id, userName: name, enterCode: password));

        await serviceDiary.save();

        setState(() {
          serviceDiary.getDiaries();
        });

        // Si la operación de guardado se completó sin errores
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Datos guardados')));
      } else {
        // Si algún campo está vacío
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Complete todos los campos')));
      }
    } catch (e) {
      // Si ocurre algún error durante la inserción
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ocurrió un error al guardar los datos')));
      print('Error al guardar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Diary'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildInput(context, _id, _nameDiary, _password),
            const SizedBox(height: 20),
            _buildButton(context),
            const SizedBox(height: 20),
            _buildShow(context, serviceDiary),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(BuildContext context, TextEditingController id,
      TextEditingController userName, TextEditingController enterCode) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: id,
              decoration: const InputDecoration(labelText: 'id'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: userName,
              decoration: const InputDecoration(labelText: 'userName'),
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: enterCode,
              decoration: const InputDecoration(labelText: 'enterCode'),
              keyboardType: TextInputType.name,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      alignment: Alignment.center,
      child: SizedBox(
        width: 400,
        child: ElevatedButton(
          onPressed: () {
            // Lógica para crear/actualizar un registro Diary
            _insertarDatosDiary();
          },
          child: const Text('registrar'),
        ),
      ),
    );
  }

  Widget _buildShow(BuildContext context, ServiceDiary serviceDiary) {
    // Widget para mostrar los datos obtenidos de la base de datos
    return Container(
      width: 400,
      height: 400,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: FutureBuilder<List<MoDiary>>(
        // Lógica para obtener los Diarios y mostrarlos en esta sección
        future: serviceDiary.getDiaries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final diaryList = snapshot.data!;
            // Lógica para mostrar la lista de diarios en esta sección
            return ListView.builder(
              shrinkWrap: true,
              itemCount: diaryList.length,
              itemBuilder: (context, index) {
                final diary = diaryList[index];
                return ListTile(
                  leading: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        Text(diary.id.toString()),
                        const MaxGap(10),
                        Text(diary.userName),
                        const MaxGap(10),
                        Text(diary.enterCode)
                      ],
                    ),
                  ),
                  title: Row(
                    children: [
                      TextButton(onPressed: () {}, child: const Text('Update')),
                      TextButton(
                          onPressed: () {
                            serviceDiary.delete(diaryList[index].id);
                          },
                          child: const Text('Delete')),
                    ],
                  ),
                  // Aquí podrías añadir más información del Diary si es necesario
                );
              },
            );
          } else {
            return const Text('No hay datos disponibles');
          }
        },
      ),
    );
  }
}
