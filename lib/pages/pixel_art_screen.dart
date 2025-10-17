import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/configuration_data.dart';
import 'package:logger/logger.dart';

class PixelArtScreen extends StatefulWidget {
  const PixelArtScreen({super.key});

  @override
  State<PixelArtScreen> createState() => _PixelArtScreenState();
}

class _PixelArtScreenState extends State<PixelArtScreen> {
  final Logger logger = Logger();
  final SharedServices _prefsService = SharedServices();

  late List<Color> _cellColors;
  late int _sizeGrid;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _loadGrid();
  }

  Future<void> _loadGrid() async {
    try {
      _sizeGrid = await _prefsService.loadSize();
      final savedGrid = await _prefsService.loadGridFlat();

      if (savedGrid != null && savedGrid.length == _sizeGrid * _sizeGrid) {
        _cellColors = savedGrid;
        logger.d("Grilla cargada desde SharedPreferences");
      } else {
        _cellColors =
            List<Color>.generate(_sizeGrid * _sizeGrid, (_) => Colors.white);
        logger.d("Nueva grilla creada con tamaño $_sizeGrid x $_sizeGrid");
      }

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      logger.e("Error al cargar grilla: $e");
    }
  }

  Future<void> _paintCell(int index) async {
    final color = context.read<ConfigurationData>().selectedColor;
    setState(() {
      _cellColors[index] = color;
    });
    await _prefsService.saveGridFlat(_cellColors);
    logger.d("Celda $index pintada con color $color");
  }

  Color _getTextColor(Color background) {
    return background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixel Art'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _sizeGrid),
              itemCount: _sizeGrid * _sizeGrid,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _paintCell(index),
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    color: _cellColors[index],
                    child: Center(
                      child: Text(
                        '$index',
                        style: TextStyle(
                          color: _getTextColor(_cellColors[index]),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
