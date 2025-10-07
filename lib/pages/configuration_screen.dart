import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/configuration_data.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  final List<int> pixelSizes = [16, 18, 20, 22, 24];
  final List<Color> colors = [Colors.black, Colors.red, Colors.green, Colors.blue, Colors.yellow];

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigurationData>();

    int currentSize = pixelSizes.contains(config.size) ? config.size : pixelSizes[0];
    Color currentColor = colors.contains(config.selectedColor) ? config.selectedColor : colors[0];

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tamaño del Pixel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              initialValue: currentSize,
              items: pixelSizes
                  .map((size) => DropdownMenuItem(
                        value: size,
                        child: Text('$size px'),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<ConfigurationData>().setSize(value);
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Seleccione el tamaño del pixel',
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Color de la paleta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<Color>(
              initialValue: currentColor,
              items: colors
                  .map(
                    (color) => DropdownMenuItem(
                      value: color,
                      child: Row(
                        children: [
                          Container(width: 24, height: 24, color: color),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 120, 
                            child: Text(
                              color.toString().split('(')[1].split(')')[0],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (color) {
                if (color != null) {
                  context.read<ConfigurationData>().setColor(color);
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Seleccionar color',
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Vista previa',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: config.size.toDouble(),
                    height: config.size.toDouble(),
                    color: config.selectedColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
