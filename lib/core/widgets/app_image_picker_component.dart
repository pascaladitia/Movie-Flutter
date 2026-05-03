import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class AppImagePickerComponent {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickAndCompressImage(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return null;

    final picked = await _picker.pickImage(source: source, imageQuality: 100);
    if (picked == null) return null;

    final compressedPath = '${Directory.systemTemp.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final compressed = await FlutterImageCompress.compressAndGetFile(
      picked.path,
      compressedPath,
      quality: 75,
      minWidth: 1024,
      minHeight: 1024,
    );

    return compressed?.path ?? picked.path;
  }
}
