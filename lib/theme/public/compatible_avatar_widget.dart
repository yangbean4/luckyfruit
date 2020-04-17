import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CompatibleNetworkAvatarWidget extends StatelessWidget {
  final String imageUrl;
  final num width;
  final num height;
  final BoxFit fit;
  final String defaultImageUrl;

  CompatibleNetworkAvatarWidget(this.imageUrl,
      {this.width, this.height, this.fit, this.defaultImageUrl});
  @override
  Widget build(BuildContext context) {
    return imageUrl != null && imageUrl.isNotEmpty
        ? Image(
            image: CachedNetworkImageProvider(imageUrl),
            width: width,
            height: height,
            fit: fit,
          )
        : Image.asset(
            defaultImageUrl,
            width: width,
            height: height,
            fit: fit,
          );
  }
}
