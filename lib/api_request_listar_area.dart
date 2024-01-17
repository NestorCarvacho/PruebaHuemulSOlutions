import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiRequestListarArea extends StatelessWidget {
  static const String rutaMutualValidaInfra =
      "https://af-mutual-valida-dev-001.azurewebsites.net/api/";
  final String apiUrl = "${rutaMutualValidaInfra}department/v1/";

  Future<List<Map<String, String>>> fetchData(int number) async {
    final response = await http.get(Uri.parse('$apiUrl$number'));
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Parsed data: $data');

      if (data != null &&
          data is Map<String, dynamic> &&
          data.containsKey('data') &&
          data['data'] is List &&
          data['data'].isNotEmpty) {
        final department = data['data'][0];
        final departmentName = department['departmentName']?.toString() ??
            'el valor es nulo departmentName';
        final departmentDesc = department['departmentDesc']?.toString() ??
            'el valor es nulo departmentDesc';

        return [
          {
            'departmentName': departmentName,
            'departmentDesc': departmentDesc,
          }
        ];
      } else {
        throw Exception('La respuesta no tiene la estructura esperada');
      }
    } else {
      throw Exception(
          'Sin Informacion. Código de estado: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Areas'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          int departmentNumber = index + 1;
          return FutureBuilder(
            future: fetchData(departmentNumber),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final departmentData = snapshot.data?[0];
                if (departmentData != null) {
                  return ListTile(
                    title: Text(departmentData['departmentName']!),
                    subtitle: Text(departmentData['departmentDesc']!),
                  );
                } else {
                  return const Text('Datos nulos');
                }
              }
            },
          );
        },
      ),
    );
  }
}
