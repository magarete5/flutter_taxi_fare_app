import 'package:flutter_taxi_fare_app/views/splash_screen_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const FlutterTaxiFareApp());
}

class FlutterTaxiFareApp extends StatelessWidget {
  const FlutterTaxiFareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taxi Fare',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFEF7FF),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        textTheme: GoogleFonts.kanitTextTheme(),
      ),
      // กำหนดให้ SplashScreenUi เป็นหน้าจอแรก
      home: const SplashScreenUi(),
    );
  }
}
