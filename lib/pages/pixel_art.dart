import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/providers/configuration_data.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PixelArt extends StatefulWidget {
  const PixelArt({super.key});

  @override
  State<PixelArt> createState() => _PixelArtState();
}

class _PixelArtState extends State<PixelArt> {
  final Logger logger = Logger();
  final SharedServices _prefsService = SharedServices();

  late List<Color> _cellColors;
  late int _sizeGrid;
  late Color _selectedColor;
  bool _showNumbers = true;
  final TextEditingController _titleController = TextEditingController();

  final List<Color> _listColors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.brown,
    Colors.grey,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    _cellColors = [];
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final config = context.read<ConfigurationData>();
      _sizeGrid = config.size;
      _selectedColor = config.selectedColor;

      final savedGrid = await _prefsService.loadGridFlat();
      if (savedGrid != null && savedGrid.length == _sizeGrid * _sizeGrid) {
        _cellColors = savedGrid;
        logger.d("Grilla cargada desde SharedPreferences");
      } else {
        _cellColors =
            List<Color>.generate(_sizeGrid * _sizeGrid, (_) => Colors.white);
        logger.d("Nueva grilla creada ($_sizeGrid x $_sizeGrid)");
      }

      setState(() {});
    } catch (e) {
      logger.e("Error al cargar la grilla: $e");
    }
  }

  Future<void> _saveGrid() async {
    await _prefsService.saveGridFlat(_cellColors);
  }

  Future<void> _paintCell(int index) async {
    setState(() {
      _cellColors[index] = _selectedColor;
    });
    await _saveGrid();
    logger.d("Celda $index pintada con color $_selectedColor");
  }

  Color _getTextColor(Color background) {
    if (!_showNumbers) return Colors.transparent;
    if (background == Colors.transparent) return Colors.black;
    return background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  Future<void> _saveCreation() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor ingresa un título")),
      );
      return;
    }

    await context.read<ConfigurationData>().addCreation(title);
    logger.d("Creación guardada con título: $title");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Creación '$title' guardada")),
    );
  }

  Future<String?> _savePixelArt(String title) async {
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint();

      final cellSize = 20.0; 
      for (int y = 0; y < _sizeGrid; y++) {
        for (int x = 0; x < _sizeGrid; x++) {
          paint.color = _cellColors[y * _sizeGrid + x];
          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            paint,
          );
        }
      }

      final picture = recorder.endRecording();
      final img = await picture.toImage(
        (_sizeGrid * cellSize).toInt(),
        (_sizeGrid * cellSize).toInt(),
      );
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$title.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      await context.read<ConfigurationData>().addCreation(filePath);

      return filePath;
    } catch (e) {
      logger.e("Error al guardar imagen: $e");
      return null;
    }
  }

  Future<void> _shareGrid() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingresa un título para compartir")),
      );
      return;
    }

    final path = await _savePixelArt(_titleController.text.trim());
    if (path != null) {
      await Share.shareXFiles([XFile(path)], text: 'Mira mi Pixel Art!');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cellColors.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixel Art - Guardado de Creaciones'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Mostrar números'),
                      Switch(
                        value: _showNumbers,
                        onChanged: (value) {
                          setState(() => _showNumbers = value);
                        },
                      ),
                      const SizedBox(width: 16),
                      Text('$_sizeGrid x $_sizeGrid'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: 'Nombre de la creación',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _saveCreation(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _saveCreation,
                        child: const Text('Guardar'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _shareGrid,
                        child: const Text('Compartir'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _sizeGrid,
                ),
                itemCount: _sizeGrid * _sizeGrid,
                itemBuilder: (context, index) {
                  final cellColor = _cellColors[index];
                  return GestureDetector(
                    onTap: () => _paintCell(index),
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      color: cellColor,
                      child: Center(
                        child: Text(
                          _showNumbers ? '$index' : '',
                          style: TextStyle(
                            color: _getTextColor(cellColor),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey[200],
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _listColors.map((color) {
                    final bool isSelected = color == _selectedColor;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedColor = color);
                        context.read<ConfigurationData>().setColor(color);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.all(isSelected ? 12 : 8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                        width: isSelected ? 36 : 28,
                        height: isSelected ? 36 : 28,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
