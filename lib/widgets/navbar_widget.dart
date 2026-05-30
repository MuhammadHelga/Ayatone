import 'package:flutter/material.dart';
import 'package:ayatone/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:ayatone/controllers/navbar_controller.dart';
import 'package:ayatone/controllers/play_screen_controller.dart';
import 'package:ayatone/pages/home_page.dart';
import 'package:ayatone/pages/search_page.dart';
import 'package:ayatone/pages/saved_page.dart';

class NavBar extends StatelessWidget {
  NavBar({super.key});

  final NavBarController navBarController = Get.put(NavBarController());
  final PlayScreenController playController =
      Get.put(PlayScreenController(), permanent: true);
  final List<Widget> screens = [HomePage(), SearchPage(), SavedPage()];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Obx(
      () => Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: navBarController.selectedIndex.value,
          children: screens,
        ),
        bottomNavigationBar: SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(width * 0.03),
            child: BottomNavigationBar(
              backgroundColor: Appcolors.surface,
              currentIndex: navBarController.selectedIndex.value,
              onTap: (index) => navBarController.changeIndex(index),
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              selectedItemColor: Appcolors.primary,
              unselectedItemColor: Appcolors.dim,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    navBarController.selectedIndex.value == 0
                        ? Icons.home
                        : Icons.home_outlined,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    navBarController.selectedIndex.value == 1
                        ? Icons.search
                        : Icons.search_outlined,
                  ),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    navBarController.selectedIndex.value == 2
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                  ),
                  label: 'Bookmark',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
