import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Pixel Art sobre una grilla personalizable', style: TextStyle(fontSize: 15),),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
        
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:
              Row(
                children: [
                  Image.asset( "assets/Pixel-Art-Pizza-2.webp", width: 400, fit: BoxFit.cover),
                  Image.asset( "assets/Pixel-Art-Hot-Pepper-2-1.webp", width: 400, fit: BoxFit.cover),
                  Image.asset( "assets/Pixel-Art-Watermelon-3.webp", width: 400, fit: BoxFit.cover),
                ],
              ),
            ),
          ],
        ),
      ),
      

      floatingActionButton: _buildFloatingButtons(),
      
    );
  }
}