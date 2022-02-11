import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class CRPNetworkImage extends StatelessWidget {
  final String imageURL;

  const CRPNetworkImage({
    Key? key,
    required this.imageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageURL,
    );
  }
}