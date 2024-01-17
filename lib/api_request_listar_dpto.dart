// import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiRequest {
  final String name;
  final String method;
  final String url;
  final Map<String, String> headers;
  final String body;

  ApiRequest({
    required this.name,
    required this.method,
    required this.url,
    required this.headers,
    required this.body,
  });

  factory ApiRequest.fromJson(Map<String, dynamic> json) {
    final request = json['request'];

    if (request != null) {
      final List<MapEntry<String, String>> rawHeaders =
          List<MapEntry<String, String>>.from(
        (request['headers'] ?? request['header'] as List).map((header) {
          return MapEntry<String, String>(
              header['key'] as String, header['value'] as String);
        }),
      );

      final headers = Map.fromEntries(rawHeaders);

      return ApiRequest(
        name: json['name'],
        method: request['method'],
        url: request['url']['raw'],
        headers: headers,
        body: request['body']['raw'],
      );
    } else {
      return ApiRequest(
        name: json['name'],
        method: '',
        url: '',
        headers: {},
        body: '',
      );
    }
  }
}

class ApiResponse {
  final List<Map<String, dynamic>> data;

  ApiResponse({required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: List<Map<String, dynamic>>.from(json['data'] ?? []),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchApiResponse() async {
  const String rutaMutualValidaInfra =
      "https://af-mutual-valida-dev-001.azurewebsites.net/api/";

  final response =
      await http.get(Uri.parse('${rutaMutualValidaInfra}department/v1'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseJson = json.decode(response.body);
    final ApiResponse apiResponse = ApiResponse.fromJson(responseJson);
    return apiResponse.data;
  } else {
    throw Exception('Error al cargar datos desde la API');
  }
}
