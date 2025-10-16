import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/configuration_data.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PixelArtScreen extends StatefulWidget {
  final bool showNumbers;

  const PixelArtScreen({super.key, this.showNumbers = false});

  @override
  State<PixelArtScreen> createState() => _PixelArtScreenState();
}

class _PixelArtScreenState extends State<PixelArtScreen> {
  var logger = Logger();
  late int _sizeGrid;
  late List<List<Color>> _gridColors;

  @override
  void initState() {
    super.initState();
    _sizeGrid = context.read<ConfigurationData>().size;
    _initializeGrid();
    logger.d("PixelArtScreen initialized with grid size $_sizeGrid");
  }

  void _initializeGrid() {
    _gridColors = List.generate(
      _sizeGrid,
      (_) => List.generate(_sizeGrid, (_) => Colors.white),
    );
  }

  void _paintCell(int row, int col) {
    setState(() {
      final color = context.read<ConfigurationData>().selectedColor;
      _gridColors[row][col] = color;
      logger.d("Cell [$row,$col] painted with color $color");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixel Art'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_sizeGrid, (row) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(_sizeGrid, (col) {
                  return GestureDetector(
                    onTap: () => _paintCell(row, col),
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _gridColors[row][col],
                        border: Border.all(color: Colors.grey),
                      ),
                      child: widget.showNumbers
                          ? Text(
                              '$row,$col',
                              style: const TextStyle(
                                  fontSize: 8, color: Colors.black),
                            )
                          : null,
                    ),
                  );
                }),
              );
            }),
          ),
        ),
      ),
    );
  }
}
