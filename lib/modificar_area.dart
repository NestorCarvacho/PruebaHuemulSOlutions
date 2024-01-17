import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';

class ModificarArea extends StatefulWidget {
  static const String rutaMutualValidaInfra =
      "https://af-mutual-valida-dev-001.azurewebsites.net/api/";
  final String apiUrl = "${rutaMutualValidaInfra}department/v1/";

  @override
  _ModificarAreaState createState() => _ModificarAreaState();
}

class _ModificarAreaState extends State<ModificarArea> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  TextEditingController _busquedaController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _busquedaController.dispose();
    super.dispose();
  }

  Future<void> _buscarDepartamento() async {
    String busqueda = _busquedaController.text;

    bool departamentoExiste = await _verificarExistenciaDepartamento(busqueda);

    if (departamentoExiste) {
      _mostrarFormularioModificacion();
    } else {
      _mostrarMensajeError();
    }
    // Obtener los valores del formulario de búsqueda
  }

  Future<bool> _verificarExistenciaDepartamento(String busqueda) async {
    final response = await http.get(Uri.parse('${widget.apiUrl}$busqueda'));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  void _mostrarMensajeError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('No existe departamento con el nombre proporcionado.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

///////////////////////////////////////////////////////////////////////////////////////////
  Future<void> _mostrarFormularioModificacion() async {
    // Mostrar el formulario de modificación con el resultado obtenido
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modificar Departamento'),
          content: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                    labelText: 'Nuevo nombre del departamento'),
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                    labelText: 'Nueva descripción del departamento'),
              ),
              ElevatedButton(
                onPressed: () {
                  _modificarDepartamento();
                  Navigator.of(context)
                      .pop(); // Cerrar el diálogo después de modificar
                },
                child: Text('Modificar Departamento'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _modificarDepartamento() async {
    // Obtener los valores del formulario de modificación
    String busqueda = _busquedaController.text;
    String nuevoNombre = _nombreController.text;
    String nuevaDescripcion = _descripcionController.text;

    try {
      final response = await http.put(
        Uri.parse('${widget.apiUrl}$busqueda'),
        body: jsonEncode({
          'departmentName': nuevoNombre,
          'departmentDesc': nuevaDescripcion,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Departamento modificado con éxito
        print('Departamento modificado con éxito');
      } else {
        // Error al modificar el departamento
        print(
            'Error al modificar el departamento. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      // Manejar el error, por ejemplo, mostrando un mensaje o registrándolo
      print('Error al modificar el departamento: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Departamento'),
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
            controller: _busquedaController,
            decoration: InputDecoration(labelText: 'Buscar departamento'),
          ),
          ElevatedButton(
            onPressed: () {
              _buscarDepartamento();
            },
            child: Text('Buscar'),
          ),
        ],
      ),
    );
  }
}
