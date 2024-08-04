import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController {
  late PageController pageController;
  late Timer timer;
  int currentPage = 0;
  List<String> bannerImages = [];
  bool hasBannerImages = false;

  void init() {
    pageController = PageController(initialPage: currentPage);
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      int nextPage = (pageController.page?.toInt() ?? 0) + 1;
      if (nextPage >= bannerImages.length) {
        nextPage = 0; // Loop back to the first page
      }
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> fetchBannerImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cachedImages = prefs.getStringList('banner_images');
    int? lastFetchTime = prefs.getInt('last_fetch_time');

    int cacheExpiryTime = 2 * 60 * 60 * 1000; // 2 hours

    if (cachedImages != null &&
        cachedImages.isNotEmpty &&
        lastFetchTime != null &&
        DateTime.now().millisecondsSinceEpoch - lastFetchTime < cacheExpiryTime) {
      bannerImages = cachedImages;
      hasBannerImages = bannerImages.isNotEmpty;
    } else {
      bannerImages = await _downloadBannerImages();
      hasBannerImages = bannerImages.isNotEmpty;
      prefs.setStringList('banner_images', bannerImages);
      prefs.setInt('last_fetch_time', DateTime.now().millisecondsSinceEpoch);
    }
  }

  Future<List<String>> _downloadBannerImages() async {
    ListResult result = await FirebaseStorage.instance.ref('app_data/banners').listAll();
    List<String> urls = [];
    for (var ref in result.items) {
      String url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  void dispose() {
    timer.cancel();
    pageController.dispose();
  }
}
