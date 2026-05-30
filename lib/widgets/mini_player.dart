import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ayatone/theme/app_colors.dart';
import '../controllers/play_screen_controller.dart';
import '../screens/play_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final PlayScreenController playController =
        Get.find<PlayScreenController>();
    double width = MediaQuery.of(context).size.width;

    return Obx(() {
      final surah = playController.currentPlayingSurah;
      if (surah == null) {
        return const SizedBox.shrink();
      }

      final int surahNumber = surah['number'];
      final String name = surah['englishName'] ?? '';
      final int ayahsCount = surah['numberOfAyahs'] ?? 0;

      return GestureDetector(
        onTap: () => Get.to(() => const PlayScreen()),
        child: Container(
          margin:
              EdgeInsets.fromLTRB(width * 0.04, 0, width * 0.04, width * 0.25),
          padding: EdgeInsets.all(width * 0.02),
          decoration: BoxDecoration(
            color: Appcolors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Appcolors.primary.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            gradient: const LinearGradient(
              colors: [Appcolors.primary, Color(0xFF0F7A59)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  surahNumber.toString(),
                  style: const TextStyle(
                    fontFamily: 'NotoSerif',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'NotoSerif',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${playController.selectedQari.value.name} • $ayahsCount Ayat',
                      style: TextStyle(
                        fontFamily: 'NotoSerif',
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  playController.isAudioPlaying.value
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
                onPressed: () => playController.togglePlaySurah(surahNumber),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () => playController.stopSurah(),
              ),
            ],
          ),
        ),
      );
    });
  }
}
