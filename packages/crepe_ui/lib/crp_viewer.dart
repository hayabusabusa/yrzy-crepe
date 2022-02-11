import 'package:flutter/material.dart';

import 'package:crepe_ui/crp_network_image.dart';

class CRPViewer extends StatelessWidget {
  final List<String> imageURLs;

  const CRPViewer({
    required this.imageURLs,
    Key? key 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: imageURLs.length,
      itemBuilder: (_, index) {
        return CRPNetworkImage(imageURL: imageURLs[index]);
      },
      reverse: true,
    );
  }
}
