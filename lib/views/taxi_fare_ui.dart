import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

// หน้าคำนวณค่าโดยสารแท็กซี่
class TaxiFareUi extends StatefulWidget {
  const TaxiFareUi({super.key});

  @override
  State<TaxiFareUi> createState() => _TaxiFareUiState();
}

class _TaxiFareUiState extends State<TaxiFareUi> {
  final TextEditingController distanceCtrl = TextEditingController();
  final TextEditingController trafficCtrl = TextEditingController();

  double fare = 0;

  static const Color amber = Color(0xFFFFC107);

  @override
  void dispose() {
    distanceCtrl.dispose();
    trafficCtrl.dispose();
    super.dispose();
  }

  // อัตราค่าโดยสารแท็กซี่มิเตอร์ (คิดสะสมทีละช่วงระยะทาง)
  //   กิโลเมตรแรก: 35 บาท
  //   กิโลเมตรที่ 2–10: กิโลเมตรละ 6.50 บาท
  //   กิโลเมตรที่ 10–20: กิโลเมตรละ 7.00 บาท
  //   กิโลเมตรที่ 20–40: กิโลเมตรละ 8.00 บาท
  //   กิโลเมตรที่ 40–60: กิโลเมตรละ 8.50 บาท
  //   กิโลเมตรที่ 60–80: กิโลเมตรละ 9.00 บาท
  //   ระยะทางเกิน 80 กม. ขึ้นไป: กิโลเมตรละ 10.50 บาท
  double distanceFare(double km) {
    if (km <= 0) return 0;
    // [ระยะทางสิ้นสุดของช่วง, อัตราต่อกิโลเมตรของช่วง]
    const tiers = [
      [10.0, 6.5],
      [20.0, 7.0],
      [40.0, 8.0],
      [60.0, 8.5],
      [80.0, 9.0],
      [double.infinity, 10.5],
    ];
    double total = 35; // กิโลเมตรแรก
    double start = 1;
    for (final tier in tiers) {
      final end = tier[0];
      final rate = tier[1];
      if (km > start) {
        final kmInTier = (km < end ? km : end) - start;
        total += kmInTier * rate;
      }
      start = end;
    }
    return total;
  }

  void calculateFare() {
    final distance = double.tryParse(distanceCtrl.text.trim());
    final traffic = double.tryParse(trafficCtrl.text.trim());
    if (distance == null || traffic == null || distance < 0 || traffic < 0) {
      showWarning('กรุณากรอกข้อมูลให้ครบถ้วน');
      return;
    }
    setState(() {
      // กรณีรถติด คิดนาทีละ 3.00 บาท
      fare = distanceFare(distance) + (traffic * 3.0);
    });
    FocusScope.of(context).unfocus();
  }

  void cancel() {
    setState(() {
      distanceCtrl.clear();
      trafficCtrl.clear();
      fare = 0;
    });
  }

  void showWarning(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFF44336),
          content: Row(
            children: [
              const Icon(Icons.warning, color: amber),
              const SizedBox(width: 14),
              Text(
                message,
                style: GoogleFonts.kanit(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
        ),
      );
  }

  // ป้ายชื่อ + ช่องป้อนตัวเลข
  Widget numberField({
    required String label,
    required String iconAsset,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.kanit(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(iconAsset, width: 24, height: 24),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.kanit(fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.kanit(
              fontSize: 15,
              color: const Color(0xFF49454F),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 18,
            ),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  // ปุ่มเต็มความกว้าง
  Widget actionButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.kanit(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: amber,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Taxi Fare',
          style: GoogleFonts.kanit(fontSize: 21, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(42, 56, 42, 36),
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/taxi.png', width: 208),
              const SizedBox(height: 40),
              Text(
                'คำนวณค่าโดยสารแท็กซี่',
                style: GoogleFonts.kanit(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 22),
              numberField(
                label: 'ระยะทาง (กิโลเมตร)',
                iconAsset: 'assets/images/road.png',
                hintText: 'กรุณากรอกระยะทาง',
                controller: distanceCtrl,
              ),
              const SizedBox(height: 22),
              numberField(
                label: 'เวลารถติด (นาที)',
                iconAsset: 'assets/images/clock.png',
                hintText: 'กรุณากรอกเวลารถติด',
                controller: trafficCtrl,
              ),
              const SizedBox(height: 30),
              actionButton('คำนวณค่าโดยสาร', amber, calculateFare),
              const SizedBox(height: 16),
              actionButton('ยกเลิก', const Color(0xFF9E9E9E), cancel),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 22),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECB3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'ค่าโดยสารแท็กซี่',
                      style: GoogleFonts.kanit(
                        fontSize: 18,
                        color: const Color(0xFF424242),
                      ),
                    ),
                    Text(
                      fare.toStringAsFixed(2),
                      style: GoogleFonts.kanit(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF44336),
                        height: 1.4,
                      ),
                    ),
                    Text(
                      'บาท',
                      style: GoogleFonts.kanit(
                        fontSize: 18,
                        color: const Color(0xFF424242),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
