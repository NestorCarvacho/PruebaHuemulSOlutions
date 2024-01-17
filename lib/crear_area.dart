import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';

class CrearArea extends StatefulWidget {
  static const String rutaMutualValidaInfra =
      "http://af-mutual-valida-dev-001.azurewebsites.net/api/";
  final String apiUrl = "${rutaMutualValidaInfra}department/v1/";

  @override
  _CrearAreaState createState() => _CrearAreaState();
}

class _CrearAreaState extends State<CrearArea> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _crearDepartamento() async {
    // Obtener los valores del formulario
    String nombre = _nombreController.text;
    String descripcion = _descripcionController.text;

    // Configurar un cliente que siga automáticamente las redirecciones
    final client = http.Client();
    final response = await client.post(
      Uri.parse(widget.apiUrl),
      body: jsonEncode({
        'departmentName': nombre,
        'departmentDesc': descripcion,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 301) {
      // Puedes manejar la redirección según tus necesidades
      print('Se ha producido una redirección permanente');
    } else if (response.statusCode == 201) {
      print('Nuevo departamento creado con éxito');
      // Puedes realizar alguna acción adicional aquí, como volver a cargar la lista de departamentos
    } else {
      print(
          'Error al crear el departamento. Código de estado: ${response.statusCode}');
      // Puedes manejar el error de alguna manera, como mostrar un mensaje al usuario
    }

    // Cerrar el cliente para liberar recursos
    client.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nuevo Departamento'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            }),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: _nombreController,
            decoration: InputDecoration(labelText: 'Nombre del departamento'),
          ),
          TextFormField(
            controller: _descripcionController,
            decoration:
                InputDecoration(labelText: 'Descripción del departamento'),
          ),
          ElevatedButton(
            onPressed: () {
              _crearDepartamento();
            },
            child: Text('Crear Departamento'),
          ),
        ],
      ),
    );
  }
}
