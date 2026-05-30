import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../controllers/bookmark_controller.dart';
import '../widgets/card_surah.dart';
import '../widgets/filter_bar.dart';
import '../controllers/filter_controller.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final BookmarkController bookmarkController = Get.put(
    BookmarkController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Appcolors.surfaceContainer,
      appBar: AppBar(
        title: Text(
          'Surah Tersimpan',
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
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (bookmarkController.bookmarkedSurahs.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftar Simpanan Anda',
                    style: TextStyle(
                      fontFamily: 'NotoSerif',
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.04,
                      color: Appcolors.secondary,
                    ),
                  ),
                  SizedBox(height: width * 0.03),
                  const FilterBar(),
                  SizedBox(height: width * 0.03),
                ],
              );
            }),
            Expanded(
              child: Obx(() {
                if (bookmarkController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (bookmarkController.bookmarkedSurahs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(width * 0.06),
                            decoration: BoxDecoration(
                              color: Appcolors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.bookmark_border_rounded,
                              size: width * 0.18,
                              color: Appcolors.primary,
                            ),
                          ),
                          SizedBox(height: width * 0.08),
                          Text(
                            'Belum Ada Surah Disimpan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'NotoSerif',
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.05,
                              color: Appcolors.offWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final FilterController filterController =
                    Get.find<FilterController>();
                final filteredList =
                    bookmarkController.bookmarkedSurahs.where((surah) {
                      if (filterController.selectedFilter.value == 'Makkiyah') {
                        return surah['revelationType'] == 'Meccan';
                      } else if (filterController.selectedFilter.value ==
                          'Madaniyah') {
                        return surah['revelationType'] == 'Medinan';
                      }
                      return true;
                    }).toList();

                if (filteredList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada surah tersimpan dengan tipe ini',
                      style: TextStyle(
                        fontFamily: 'NotoSerif',
                        color: Appcolors.secondary,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: filteredList.length,
                  separatorBuilder:
                      (context, index) => SizedBox(height: width * 0.04),
                  itemBuilder: (context, index) {
                    final surah = filteredList[index];
                    return CardSurah(
                      number: surah['number'],
                      name: surah['englishName'] ?? '',
                      latinName: surah['name'] ?? '',
                      countAyat: surah['numberOfAyahs'] ?? 0,
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
    );
  }
}
