import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'list_art.dart';
import 'about.dart';
import 'list_creation.dart';
  
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Color _color = Colors.blue;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _restartCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _changeColor() {
    setState(() {
      if (_color == Colors.white) {
        _color = const Color.fromARGB(255, 207, 158, 252);
      } else if (_color == Color.fromARGB(255, 207, 158, 252)) {
        _color = const Color.fromARGB(255, 255, 147, 192);
      } else if (_color == Color.fromARGB(255, 255, 147, 192)) {
        _color = const Color.fromARGB(255, 166, 255, 228);
      } else {
        _color = Colors.white;
      }
    });
  }

  // Método que contiene los botones
  Widget _buildFloatingButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          onPressed: _decrementCounter,
          tooltip: 'Decrement',
          child: const Icon(Icons.remove),
        ),
        const SizedBox(width: 10), // Espacio entre los botones
        FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        const SizedBox(width: 10), // Espacio entre los botones
        FloatingActionButton(
          onPressed: _restartCounter,
          tooltip: 'Restart',
          child: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 10), // Espacio entre los botones
        FloatingActionButton(
          onPressed: _changeColor,
          backgroundColor: _color,
          tooltip: 'ChangeColor',
          child: const Icon(Icons.brush),
        ),
      ],
    );
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
              if(value == 'about'){
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
        ]
      ),

      body: Center(
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Pixel Art sobre una grilla personalizable'),
                const SizedBox(height: 10),
                //Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 10),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Image.asset("assets/Pixel-Art-Pizza-2.webp", width:200, fit: BoxFit.cover),
                      const SizedBox(width: 10),
                      Image.asset("assets/Pixel-Art-Hot-Pepper-2-1.webp", width: 200, fit: BoxFit.cover),
                      const SizedBox(width: 10),
                      Image.asset("assets/Pixel-Art-Watermelon-3.webp", width: 200, fit: BoxFit.cover),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:[
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ListArtScreen()),
                        );
                      },
                      child: const Text('Crear'),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ListCreationScreen()),
                        );
                      },
                      child: const Text('Compartir'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingButtons(), 
    );
  }
}