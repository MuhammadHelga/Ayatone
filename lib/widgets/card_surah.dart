import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayatone/theme/app_colors.dart';
import '../controllers/play_screen_controller.dart';
import '../screens/play_screen.dart';

class CardSurah extends StatelessWidget {
  final int number;
  final String name;
  final String latinName;
  final int countAyat;
  final String revelationType;
  final String audioUrl;

  const CardSurah({
    super.key,
    required this.number,
    required this.name,
    required this.latinName,
    required this.countAyat,
    required this.revelationType,
    required this.audioUrl,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final PlayScreenController playController =
        Get.find<PlayScreenController>();

    return GestureDetector(
      onTap: () async {
        if (playController.playingSurahNumber.value != number) {
          await playController.playSurahDirectly(number);
        }
        Get.to(() => const PlayScreen());
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.02,
          vertical: width * 0.05,
        ),
        decoration: BoxDecoration(
          color: Appcolors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(width * 0.03),
              decoration: BoxDecoration(
                color: Appcolors.primary,
                borderRadius: BorderRadius.circular(width * 0.03),
              ),
              child: Text(
                number.toString(),
                style: TextStyle(
                  fontFamily: 'NotoSerif',
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.04,
                  color: Appcolors.surface,
                ),
              ),
            ),
            SizedBox(width: width * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'NotoSerif',
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.04,
                    color: Appcolors.onSurface,
                  ),
                ),
                Text(
                  '$countAyat Ayat',
                  style: TextStyle(
                    fontFamily: 'NotoSerif',
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.03,
                    color: Appcolors.onSurface,
                  ),
                ),
                Text(
                  revelationType,
                  style: TextStyle(
                    fontFamily: 'NotoSerif',
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.03,
                    color: Appcolors.secondary,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              latinName,
              style: GoogleFonts.amiri(
                fontWeight: FontWeight.bold,
                fontSize: width * 0.05,
                color: Appcolors.secondary,
              ),
            ),
            SizedBox(width: width * 0.05),
          ],
        ),
      ),
    );
  }
}