import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NetworkImageSource extends StatelessWidget {
  const NetworkImageSource({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius = BorderRadius.zero,
    this.alignment = Alignment.center,
  });

  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imagePath,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        alignment: alignment,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
            alignment: alignment,
          ),
          borderRadius: borderRadius,
        ),
      ),
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
          ),
          child: Assets.img.appLogo.image(
            width: width,
            height: width,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}

class ProfileNetworkImageSource extends StatelessWidget {
  const ProfileNetworkImageSource({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius = BorderRadius.zero,
    this.alignment = Alignment.center,
  });

  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imagePath,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        alignment: alignment,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
            alignment: alignment,
          ),
          borderRadius: borderRadius,
        ),
      ),
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              image: Assets.img.defaultProfile
                  .image(
                    width: width,
                    height: width,
                  )
                  .image,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class CircleSpecialitySource extends StatelessWidget {
  const CircleSpecialitySource({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.alignment = Alignment.center,
  });

  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imagePath,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        alignment: alignment,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
            alignment: alignment,
          ),
          shape: BoxShape.circle,
        ),
      ),
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.grey.shade100,
            image: DecorationImage(
              image: Assets.img.healthcare
                  .image(
                    width: width,
                    height: width,
                    color: AppColors.grey.shade300,
                  )
                  .image,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
