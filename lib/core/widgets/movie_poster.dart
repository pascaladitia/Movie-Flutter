import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/api_constants.dart';

class MoviePoster extends StatelessWidget {
  final String? path;
  final double width;
  final double height;

  const MoviePoster({super.key, required this.path, this.width = 110, this.height = 160});

  @override
  Widget build(BuildContext context) {
    if (path == null || path!.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported_outlined),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        width: width,
        height: height,
        fit: BoxFit.cover,
        imageUrl: '${ApiConstants.posterBaseUrl}${path!}',
        placeholder: (context, url) => Container(color: Colors.grey.shade200),
      ),
    );
  }
}
