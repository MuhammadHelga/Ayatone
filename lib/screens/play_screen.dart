import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/play_screen_controller.dart';
import '../controllers/bookmark_controller.dart';
import '../theme/app_colors.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final PlayScreenController controller = Get.find<PlayScreenController>();
    final BookmarkController bookmarkController =
        Get.find<BookmarkController>();

    return Scaffold(
      backgroundColor: Appcolors.surfaceContainer,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Appcolors.onSurface,
          ),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Memutar Surah',
              style: TextStyle(
                fontFamily: 'NotoSerif',
                fontWeight: FontWeight.bold,
                fontSize: width * 0.05,
                color: Appcolors.onSurface,
              ),
            ),
            Obx(() {
              final surah = controller.currentPlayingSurah;
              final isSaved =
                  surah != null &&
                  bookmarkController.isBookmarked(surah['number']);
              return IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved ? Appcolors.primary : Appcolors.onSurface,
                ),
                onPressed:
                    surah == null
                        ? null
                        : () => bookmarkController.toggleBookmark(surah),
              );
            }),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        final surah = controller.currentPlayingSurah;

        if (surah == null) {
          return const Center(
            child: Text(
              'Tidak ada surah yang sedang diputar',
              style: TextStyle(fontFamily: 'NotoSerif'),
            ),
          );
        }

        final int surahNumber = surah['number'];
        final String name = surah['englishName'] ?? '';
        final String arabicName = surah['name'] ?? '';
        final String revelationType =
            surah['revelationType'] == 'Meccan' ? 'Makkiyah' : 'Madaniyah';
        final int ayahsCount = surah['numberOfAyahs'] ?? 0;

        double currentPositionMs =
            controller.position.value.inMilliseconds.toDouble();
        double totalDurationMs =
            controller.duration.value.inMilliseconds.toDouble();

        if (currentPositionMs > totalDurationMs) {
          currentPositionMs = totalDurationMs;
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: double.infinity,
                height: height * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Appcolors.primary, Color(0xFF0F7A59)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Appcolors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(width * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'SURAH KE-$surahNumber',
                              style: TextStyle(
                                fontFamily: 'NotoSerif',
                                color: Appcolors.surface,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.035,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.03),
                          Text(
                            arabicName,
                            style: GoogleFonts.amiri(
                              color: Appcolors.surface,
                              fontSize: width * 0.08,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Text(
                            name,
                            style: TextStyle(
                              fontFamily: 'NotoSerif',
                              color: Appcolors.surface,
                              fontSize: width * 0.055,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$revelationType • $ayahsCount Ayat',
                            style: TextStyle(
                              fontFamily: 'NotoSerif',
                              color: Appcolors.surface.withValues(alpha: 0.8),
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap:
                                () => _showQariSelectionBottomSheet(
                                  context,
                                  controller,
                                  width,
                                ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    controller.selectedQari.value.name,
                                    style: TextStyle(
                                      fontFamily: 'NotoSerif',
                                      color: Appcolors.surface,
                                      fontSize: width * 0.032,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.01),
                                  Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Appcolors.surface,
                                    size: width * 0.05,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4.0,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8.0,
                      ),
                      activeTrackColor: Appcolors.primary,
                      inactiveTrackColor: Appcolors.dim,
                      thumbColor: Appcolors.primary,
                      overlayColor: Appcolors.primary.withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: currentPositionMs,
                      min: 0.0,
                      max: totalDurationMs > 0.0 ? totalDurationMs : 1.0,
                      onChanged: (value) {
                        controller.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(controller.position.value),
                          style: TextStyle(
                            fontFamily: 'NotoSerif',
                            color: Appcolors.secondary,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _formatDuration(controller.duration.value),
                          style: TextStyle(
                            fontFamily: 'NotoSerif',
                            color: Appcolors.secondary,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => controller.playPreviousSurah(),
                    icon: const Icon(Icons.skip_previous_rounded),
                    iconSize: width * 0.12,
                    color: Appcolors.primary,
                    splashRadius: 30,
                    tooltip: 'Surah Sebelumnya',
                  ),
                  SizedBox(width: width * 0.06),
                  GestureDetector(
                    onTap: () => controller.togglePlaySurah(surahNumber),
                    child: Container(
                      width: width * 0.2,
                      height: width * 0.2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Appcolors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: Appcolors.primary.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        controller.isAudioPlaying.value
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Appcolors.surface,
                        size: width * 0.1,
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.06),
                  IconButton(
                    onPressed: () => controller.playNextSurah(),
                    icon: const Icon(Icons.skip_next_rounded),
                    iconSize: width * 0.12,
                    color: Appcolors.primary,
                    splashRadius: 30,
                    tooltip: 'Surah Selanjutnya',
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      }),
    );
  }

  void _showQariSelectionBottomSheet(
    BuildContext context,
    PlayScreenController controller,
    double width,
  ) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.06,
          vertical: width * 0.05,
        ),
        decoration: const BoxDecoration(
          color: Appcolors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Appcolors.dim,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Pilih Qari (Pembaca)',
              style: TextStyle(
                fontFamily: 'NotoSerif',
                fontWeight: FontWeight.bold,
                fontSize: width * 0.048,
                color: Appcolors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pilih suara qari favorit Anda untuk memutar surah.',
              style: TextStyle(
                fontFamily: 'NotoSerif',
                fontSize: width * 0.034,
                color: Appcolors.secondary,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              final selectedId = controller.selectedQari.value.id;
              return ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.listQari.length,
                separatorBuilder:
                    (context, index) => Divider(
                      color: Appcolors.dim.withValues(alpha: 0.5),
                      height: 1,
                    ),
                itemBuilder: (context, index) {
                  final qari = controller.listQari[index];
                  final isSelected = selectedId == qari.id;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      controller.changeQari(qari);
                      Get.back();
                    },
                    title: Text(
                      qari.name,
                      style: TextStyle(
                        fontFamily: 'NotoSerif',
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.038,
                        color:
                            isSelected
                                ? Appcolors.primary
                                : Appcolors.onSurface,
                      ),
                    ),
                    trailing:
                        isSelected
                            ? const Icon(
                              Icons.check_circle_rounded,
                              color: Appcolors.primary,
                            )
                            : null,
                  );
                },
              );
            }),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
