import 'package:flutter/material.dart';
import 'package:ayatone/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/home_page_controller.dart';
import '../controllers/play_screen_controller.dart';
import '../widgets/filter_bar.dart';
import '../widgets/card_surah.dart';
import '../widgets/mini_player.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomePageController controller = Get.put(HomePageController());
  final PlayScreenController playController = Get.find<PlayScreenController>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Appcolors.surfaceContainer,
      appBar: AppBar(
        title: Text(
          'Ayatone',
          style: TextStyle(
            fontFamily: 'NotoSerif',
            fontWeight: FontWeight.bold,
            fontSize: width * 0.06,
            color: Appcolors.onSurface,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              width * 0.05,
              width * 0.05,
              width * 0.05,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Assalamu'alaikum",
                  style: TextStyle(
                    fontFamily: 'NotoSerif',
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.04,
                    color: Appcolors.secondary,
                  ),
                ),
                Text(
                  "Selamat Mendengarkan Al-Qur'an",
                  style: TextStyle(
                    fontFamily: 'NotoSerif',
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.04,
                    color: Appcolors.primary,
                  ),
                ),
                SizedBox(height: width * 0.03),
                const FilterBar(),
                SizedBox(height: width * 0.03),
                Text(
                  'List Surah',
                  style: TextStyle(
                    fontFamily: 'NotoSerif',
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.04,
                    color: Appcolors.onSurface,
                  ),
                ),
                SizedBox(height: width * 0.03),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.filteredSurah.isEmpty) {
                      return const Center(child: Text('Tidak ada data surah'));
                    }

                    return ListView.separated(
                      padding: EdgeInsets.only(bottom: width * 0.35),
                      itemCount: controller.filteredSurah.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final surah = controller.filteredSurah[index];
                        return CardSurah(
                          number: surah['number'],
                          name: surah['englishName'],
                          latinName: surah['name'],
                          countAyat: surah['numberOfAyahs'],
                          revelationType:
                              surah['revelationType'] == 'Meccan'
                                  ? 'Makkiyah'
                                  : 'Madaniyah',
                          audioUrl: '',
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          const Positioned(left: 0, right: 0, bottom: 0, child: MiniPlayer()),
        ],
      ),
    );
  }
}
