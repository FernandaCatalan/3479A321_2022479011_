import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class PixelArtScreen extends StatefulWidget {
  const PixelArtScreen({super.key});
 

  @override
  State<PixelArtScreen> createState() => _PixelArtScreenState();
}

class _PixelArtScreenState extends State<PixelArtScreen> {
  var logger = Logger();

  @override
  void initState() {
    super.initState();
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
