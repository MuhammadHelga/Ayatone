import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ayatone/theme/app_colors.dart';
import '../controllers/filter_controller.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final FilterController controller = Get.put(
      FilterController(),
      permanent: true,
    );

    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FilterChip(
            label: Text(
              'Semua Surah',
              style: TextStyle(
                fontFamily: 'NotoSerif',
                fontWeight: FontWeight.bold,
                fontSize: width * 0.03,
                color:
                    controller.selectedFilter.value == 'Semua'
                        ? Appcolors.surface
                        : Appcolors.onSurface,
              ),
            ),
            selected: controller.selectedFilter.value == 'Semua',
            onSelected: (value) {
              controller.changeFilter('Semua');
            },
            backgroundColor: Appcolors.surface,
            selectedColor: Appcolors.primary,
            labelStyle: TextStyle(color: Appcolors.onSurface),
            showCheckmark: false,
            elevation: 0,
          ),
          FilterChip(
            label: Text(
              'Makkiyah',
              style: TextStyle(
                fontFamily: 'NotoSerif',
                fontWeight: FontWeight.bold,
                fontSize: width * 0.03,
                color:
                    controller.selectedFilter.value == 'Makkiyah'
                        ? Appcolors.surface
                        : Appcolors.onSurface,
              ),
            ),
            selected: controller.selectedFilter.value == 'Makkiyah',
            onSelected: (value) {
              controller.changeFilter('Makkiyah');
            },
            backgroundColor: Appcolors.surface,
            selectedColor: Appcolors.primary,
            labelStyle: TextStyle(color: Appcolors.onSurface),
            showCheckmark: false,
            elevation: 0,
          ),
          FilterChip(
            label: Text(
              'Madaniyah',
              style: TextStyle(
                fontFamily: 'NotoSerif',
                fontWeight: FontWeight.bold,
                fontSize: width * 0.03,
                color:
                    controller.selectedFilter.value == 'Madaniyah'
                        ? Appcolors.surface
                        : Appcolors.onSurface,
              ),
            ),
            selected: controller.selectedFilter.value == 'Madaniyah',
            onSelected: (value) {
              controller.changeFilter('Madaniyah');
            },
            backgroundColor: Appcolors.surface,
            selectedColor: Appcolors.primary,
            labelStyle: TextStyle(color: Appcolors.onSurface),
            showCheckmark: false,
            elevation: 0,
          ),
        ],
      );
    });
  }
}
