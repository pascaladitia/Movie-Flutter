import '../../domain/entities/video_item.dart';

class VideoModel extends VideoItem {
  const VideoModel({required super.key, required super.name, required super.site, required super.type});

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
