import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class BannerCarousel extends StatefulWidget {
  final List<String> bannerImages;
  final ValueChanged<int> onPageChanged;
  final PageController pageController;

  const BannerCarousel({
    super.key,
    required this.bannerImages,
    required this.onPageChanged,
    required this.pageController,
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      int nextPage = (widget.pageController.page?.toInt() ?? 0) + 1;
      if (nextPage >= widget.bannerImages.length) {
        nextPage = 0; // Loop back to the first page
      }
      widget.pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.pageController,
      itemCount: widget.bannerImages.length,
      onPageChanged: (index) {
        widget.onPageChanged(index);
      },
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: CachedNetworkImageProvider(widget.bannerImages[index]),
              fit: BoxFit.cover,
              onError: (error, stackTrace) {
                // Handle image load error
              },
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: widget.bannerImages[index],
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        );
      },
    );
  }
}
