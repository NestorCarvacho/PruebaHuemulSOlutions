import 'package:flutter/material.dart';
import 'api_request_listar_area.dart';
import 'api_request_listar_dpto.dart' as apirequest;
import 'crear_area.dart';
import 'eliminar_area.dart';
import 'modificar_area.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedOption = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba Huemul solutions'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  _selectedOption = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Listar'),
              onTap: () {
                setState(() {
                  _selectedOption = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Crear'),
              onTap: () {
                setState(() {
                  _selectedOption = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Modificar'),
              onTap: () {
                setState(() {
                  _selectedOption = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Eliminar'),
              onTap: () {
                setState(() {
                  _selectedOption = 4;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _selectedOption == 0
          ? _bienvenida()
          : _selectedOption == 1
              ? _listar()
              : _selectedOption == 2
                  ? _crear()
                  : _selectedOption == 3
                      ? _modificar()
                      : _eliminar(),
    );
  }

  Widget _bienvenida() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Esta es una prueba para Huemul Solutions',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listar() {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: apirequest.fetchApiResponse(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No hay datos disponibles');
          } else {
            List<Map<String, dynamic>> departments = snapshot.data!;
            return ListView.builder(
              itemCount: departments.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> department = departments[index];
                return ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApiRequestListarArea(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(188, 195, 0, 255),
                    onPrimary: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombre Depto: ${department['departmentName']}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _crear() {
    return ListTile(
      title: const Text('Crear'),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CrearArea()),
        );
      },
    );
  }

  Widget _modificar() {
    return ListTile(
      title: const Text('Modificar'),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ModificarArea()),
        );
      },
    );
  }

  Widget _eliminar() {
    return ListTile(
        title: const Text('Eliminar'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EliminarArea()),
          );
        });
  }
}
