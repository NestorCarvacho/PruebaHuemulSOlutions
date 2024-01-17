import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';
// import 'dart:convert';

class EliminarArea extends StatefulWidget {
  static const String rutaMutualValidaInfra =
      "https://af-mutual-valida-dev-001.azurewebsites.net/api/";
  final String apiUrl = "${rutaMutualValidaInfra}department/v1/";

  const EliminarArea({Key? key}) : super(key: key);

  @override
  _EliminarAreaState createState() => _EliminarAreaState();
}

class _EliminarAreaState extends State<EliminarArea> {
  TextEditingController _busquedaController = TextEditingController();

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  Future<void> _buscarDepartamento() async {
    String busqueda = _busquedaController.text;
    bool departamentoExiste = await _verificarExistenciaDepartamento(busqueda);

    if (departamentoExiste) {
      // Departamento encontrado, mostrar formulario de eliminación
      _mostrarFormularioEliminacion();
    } else {
      // Departamento no encontrado, mostrar mensaje de error
      _mostrarMensajeError();
    }
  }

  Future<bool> _verificarExistenciaDepartamento(String busqueda) async {
    try {
      final response = await http.get(Uri.parse('${widget.apiUrl}$busqueda'));

      if (response.statusCode == 200) {
        // Departamento encontrado
        return true;
      } else {
        // Departamento no encontrado
        return false;
      }
    } catch (error) {
      // Manejar el error, por ejemplo, mostrando un mensaje o registrándolo
      print('Error al verificar la existencia del departamento: $error');
      return false;
    }
  }

  Future<void> _mostrarFormularioEliminacion() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Departamento'),
          content: Column(
            children: [
              Text('¿Estás seguro de que deseas eliminar este departamento?'),
              ElevatedButton(
                onPressed: () {
                  _eliminarDepartamento();
                  Navigator.of(context)
                      .pop(); // Cerrar el diálogo después de eliminar
                },
                child: Text('Eliminar Departamento'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _eliminarDepartamento() async {
    String busqueda = _busquedaController.text;

    try {
      final response =
          await http.delete(Uri.parse('${widget.apiUrl}$busqueda'));

      if (response.statusCode == 200) {
        // Departamento eliminado con éxito
        print('Departamento eliminado con éxito');
      } else {
        // Error al eliminar el departamento
        print(
            'Error al eliminar el departamento. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      // Manejar el error, por ejemplo, mostrando un mensaje o registrándolo
      print('Error al eliminar el departamento: $error');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Departamento'),
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
