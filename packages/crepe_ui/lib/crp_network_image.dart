import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class CRPNetworkImage extends StatelessWidget {
  final String imageURL;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const CRPNetworkImage({
    Key? key,
    this.width,
    this.height,
    this.fit,
    required this.imageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageURL,
      width: width,
      height: height,
      fit: fit,
    );
  }
}