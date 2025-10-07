import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/configuration_data.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PixelArtScreen extends StatefulWidget {
  const PixelArtScreen({super.key});
 

  @override
  State<PixelArtScreen> createState() => _PixelArtScreenState();
}

class _PixelArtScreenState extends State<PixelArtScreen> {
  var logger = Logger();
  int _sizeGrid = 0;

  @override
  void initState() {
    super.initState();
    _sizeGrid = context.read<ConfigurationData>().size;
    logger.d("PixelArtScreen initialized");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    logger.d("Dependencies changed in PixelArtScreen");
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    logger.d("State updated in PixelArtScreen");
  }

  @override
  void deactivate() {
    super.deactivate();
    logger.d("PixelArtScreen deactivated");
  }

  @override
  void dispose() {
    super.dispose();
    logger.d("PixelArtScreen disposed");
  }

  @override
  void reassemble() {
    super.reassemble();
    logger.d("PixelArtScreen reassembled");
  }

  @override
  Widget build(BuildContext context) {
    final size = context.watch<ConfigurationData>().size;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixel Art'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: const Center(
        child: Text('Aquí va la funcionalidad de Pixel Art'),
      ),
    );
  }

    @override
  void didUpdateWidget(covariant PixelArtScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    logger.d("Widget updated in PixelArtScreen");
  }
}
