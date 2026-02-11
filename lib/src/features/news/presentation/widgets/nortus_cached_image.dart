import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nortus/src/core/themes/app_colors.dart';

class NortusCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  const NortusCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.aspectRatio,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder:
          (context, url) => Container(
            color: AppColors.mostRecentSectionBackground,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      errorWidget:
          (context, url, error) => Container(
            color: AppColors.mostRecentSectionBackground,
            child: const Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: AppColors.newsTitleText,
              ),
            ),
          ),
      imageBuilder: (context, imageProvider) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(image: imageProvider, fit: fit),
          ),
        );
      },
    );

    if (aspectRatio != null) {
      return AspectRatio(aspectRatio: aspectRatio!, child: image);
    }

    return image;
  }
}
