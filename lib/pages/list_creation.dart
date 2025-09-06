import 'package:flutter/material.dart';

class ListCreationScreen extends StatelessWidget {
  const ListCreationScreen({super.key});

  final List<String> creations = const [
    "assets/Pixel-Art-Pizza-2.webp",
    "assets/Pixel-Art-Hot-Pepper-2-1.webp",
    "assets/Pixel-Art-Watermelon-3.webp",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Creaciones'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView.builder(
        itemCount: creations.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: Image.asset(creations[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
