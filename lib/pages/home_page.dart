import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'list_art.dart';
import 'about.dart';
import 'list_creation.dart';
import 'pixel_art.dart';
import 'configuration_screen.dart';
import '/providers/configuration_data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Color _color = Colors.blue;
  bool _showNumbers = false;
  String? _lastImagePath;

  @override
  void initState() {
    super.initState();
    _loadLastImage();
  }

  Future<void> _loadLastImage() async {
    final creations = context.read<ConfigurationData>().creations;
    if (creations.isNotEmpty) {
      final lastPath = creations.last;
      if (File(lastPath).existsSync()) {
        setState(() {
          _lastImagePath = lastPath;
        });
      } else {
        setState(() {
          _lastImagePath = null;
        });
      }
    } else {
      setState(() {
        _lastImagePath = null;
      });
    }
  }

  void _incrementCounter() => setState(() => _counter++);
  void _decrementCounter() => setState(() => _counter--);
  void _restartCounter() => setState(() => _counter = 0);

  void _changeColor() {
    setState(() {
      if (_color == Colors.white) {
        _color = const Color.fromARGB(255, 207, 158, 252);
      } else if (_color == const Color.fromARGB(255, 207, 158, 252)) {
        _color = const Color.fromARGB(255, 255, 147, 192);
      } else if (_color == const Color.fromARGB(255, 255, 147, 192)) {
        _color = const Color.fromARGB(255, 166, 255, 228);
      } else {
        _color = Colors.white;
      }
    });
  }

  Widget _buildFloatingButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          heroTag: "Decrement",
          onPressed: _decrementCounter,
          tooltip: 'Decrement',
          child: const Icon(Icons.remove),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          heroTag: "Increment",
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          heroTag: "Restart",
          onPressed: _restartCounter,
          tooltip: 'Restart',
          child: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          heroTag: "ChangeColor",
          onPressed: _changeColor,
          backgroundColor: _color,
          tooltip: 'ChangeColor',
          child: const Icon(Icons.brush),
        ),
      ],
    );
  }

  Future<void> _shareLastImage() async {
    if (_lastImagePath != null && File(_lastImagePath!).existsSync()) {
      await Share.shareXFiles([XFile(_lastImagePath!)], text: 'Mira mi Pixel Art!');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay Pixel Art para compartir")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    logger.d("Logger is working!");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'about') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem<String>(value: 'about', child: Text('About')),
              ];
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (_lastImagePath != null && File(_lastImagePath!).existsSync())
              Column(
                children: [
                  const Text(
                    "Último Pixel Art Creado",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Image.file(
                    File(_lastImagePath!),
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _shareLastImage,
                    icon: const Icon(Icons.share),
                    label: const Text('Compartir este Pixel Art'),
                  ),
                  const SizedBox(height: 20),
                ],
              )
            else
              const Text(
                "No hay Pixel Art guardados",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ListArtScreen()),
                        );
                        _loadLastImage();
                      },
                      child: const Text('Crear'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ListCreationScreen()),
                        );
                        _loadLastImage();
                      },
                      child: const Text('Compartir'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PixelArt()),
                        );
                        _loadLastImage();
                      },
                      child: const Text('Pixel Art'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ConfigurationScreen()),
                        );
                      },
                      child: const Text('Configuración'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingButtons(),
    );
  }
}
