import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/base/controllers/pages_controller.dart';
import 'package:moneycart/app/base/models/bottom_bar_model.dart';

class CustomBottomBar extends StatefulWidget {
  final List<BottomBarModel> items;

  const CustomBottomBar({super.key, required this.items});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final _pagesController = Get.put(PagesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: _pagesController.selectedTab.value,
          children: widget.items
              .asMap()
              .map((index, item) => MapEntry(
                    index,
                    Navigator(
                      key: _pagesController.navigatorKeys[index],
                      onGenerateInitialRoutes: (navigator, initialRoute) {
                        return [
                          GetPageRoute(page: () => item.page),
                        ];
                      },
                    ),
                  ))
              .values
              .toList(),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _pagesController.selectedTab.value,
          elevation: 1,
          selectedItemColor: const Color(0xCE1E1E1E),
          unselectedItemColor: const Color(0xFF9E9E9E),
          backgroundColor: const Color(0xFFF5F5F5),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            _pagesController.selectedTab.value = index;
          },
          items: widget.items
              .map(
                (item) => BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    item.icon,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF9E9E9E),
                      BlendMode.srcIn,
                    ),
                  ),
                  activeIcon: SvgPicture.asset(
                    item.activeIcon,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      item.color ?? const Color(0xCE1E1E1E),
                      BlendMode.srcIn,
                    ),
                  ),
                  label: item.title,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
