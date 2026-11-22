import 'package:flutter_taxi_fare_app/views/taxi_fare_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

// หน้าจอแรก แสดง 3 วินาทีแล้วไปหน้า TaxiFareUi
class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({super.key});

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  @override
  void initState() {
    super.initState();
    // หน่วงเวลา 3 วินาที แล้วเปิดหน้า TaxiFareUi แทนที่หน้านี้
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TaxiFareUi()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF64B5F6);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/taxi.png', width: 210),
            const SizedBox(height: 44),
            Text(
              'Taxi Fare Calculator',
              style: GoogleFonts.kanit(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: blue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'คำนวณค่าโดยสารแท็กซี่',
              style: GoogleFonts.kanit(fontSize: 17, color: blue),
            ),
            const SizedBox(height: 36),
            const SizedBox(
              width: 38,
              height: 38,
              child: CircularProgressIndicator(
                color: Color(0xFFFFC107),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
