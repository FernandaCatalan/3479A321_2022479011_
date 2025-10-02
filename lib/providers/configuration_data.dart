import 'package:flutter/material.dart';

class ConfigurationData extends StatefulWidget {
  const ConfigurationData({super.key});

  @override
  State<ConfigurationData> createState() => _ConfigurationDataState();
}

class _ConfigurationDataState extends State<ConfigurationData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Datos'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: const Center(
        child: Text('Aquí va la configuración de datos'),
      ),
    );
  }
}

class AppData extends ChangeNotifier{
  int _size= 0;
  int get size => _size;
}