import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  late PageController pageController;
  late Timer timer;
  var currentPage = 0.obs;
  var bannerImages = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentPage.value);
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
    fetchBannerImages();
  }

  Future<void> fetchBannerImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cachedImages = prefs.getStringList('banner_images');
    int? lastFetchTime = prefs.getInt('last_fetch_time');

    int cacheExpiryTime = 2 * 60 * 60 * 1000; // 2 hours

    if (cachedImages != null &&
        cachedImages.isNotEmpty &&
        DateTime.now().millisecondsSinceEpoch - lastFetchTime! < cacheExpiryTime) {
      bannerImages.addAll(cachedImages);
    } else {
      try {
        List<String> images = await _downloadBannerImages();
        bannerImages.addAll(images);
        prefs.setStringList('banner_images', images);
        prefs.setInt('last_fetch_time', DateTime.now().millisecondsSinceEpoch);
      } catch (e) {
        print('Error fetching banner images: $e');
      }
    }
  }

  Future<List<String>> _downloadBannerImages() async {
    try {
      ListResult result = await FirebaseStorage.instance.ref('app_data/banners').listAll();
      List<String> urls = [];
      for (var ref in result.items) {
        String url = await ref.getDownloadURL();
        urls.add(url);
      }
      return urls;
    } catch (e) {
      print('Error downloading images from Firebase Storage: $e');
      return [];
    }
  }

  @override
  void onClose() {
    timer.cancel();
    pageController.dispose();
    super.onClose();
  }
}
