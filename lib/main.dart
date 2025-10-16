import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:logger/logger.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home_page.dart';
import 'package:provider/provider.dart';
import 'providers/configuration_data.dart';
import 'pages/configuration_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ConfigurationData>(
      create: (context) => ConfigurationData(SharedServices()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    logger.d("Logger is working!");

    return MaterialApp(
      title: '2022479011',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 148, 2, 77)),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const MyHomePage(title: '2022479011'),
      //home: ListArtScreen(),
      //home: const ConfigurationScreen(),
    );
  }
}



