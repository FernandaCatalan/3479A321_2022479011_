import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/providers/configuration_data.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ListCreationScreen extends StatefulWidget {
  const ListCreationScreen({super.key});

  @override
  State<ListCreationScreen> createState() => _ListCreationState();
}

class _ListCreationState extends State<ListCreationScreen> {
  final Logger logger = Logger();
  final SharedServices _prefsService = SharedServices();
  List<String> _creations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCreations();
  }

  Future<void> _loadCreations() async {
    try {
      _creations = await _prefsService.loadCreations();
      logger.d("Se cargaron ${_creations.length} creaciones guardadas.");
    } catch (e) {
      logger.e("Error al cargar creaciones: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _readFile(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.txt');
      if (await file.exists()) {
        return await file.readAsString();
      } else {
        return 'Archivo no encontrado';
      }
    } catch (e) {
      return 'Error al leer archivo: $e';
    }
  }

  Future<void> _deleteCreation(String creation) async {
    setState(() {
      _creations.remove(creation);
    });
    await _prefsService.saveCreations(_creations);
    logger.d("Creación eliminada: $creation");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Creación "$creation" eliminada')));
  }

  Future<void> _shareCreation(String creation) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$creation.txt');

      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)], text: 'Mira mi Pixel Art: $creation');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Archivo no encontrado')),
        );
      }
    } catch (e) {
      logger.e("Error al compartir: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al compartir: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Creaciones Guardadas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCreations,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _creations.isEmpty
              ? const Center(
                  child: Text(
                    "Aún no tienes creaciones guardadas",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _creations.length,
                  itemBuilder: (context, index) {
                    final creationPath = _creations[index];
                    final file = File(creationPath);
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: file.existsSync()
                            ? Image.file(file, width: 40, height: 40, fit: BoxFit.cover)
                            : const Icon(Icons.broken_image, color: Colors.red),
                        title: Text(
                          creationPath.split('/').last,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCreation(creationPath),
                        ),
                        onTap: () async {
                          if (file.existsSync()) {
                            await Share.shareXFiles([XFile(creationPath)], text: 'Mira mi Pixel Art!');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Archivo no encontrado")),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
