import 'package:flutter/material.dart';

class CaseModel {
  const CaseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.categoryColor,
    required this.imageUrl,
    required this.order,
    this.url,
    this.images = const [],
    this.stack = const [],
    this.link,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final Color categoryColor;
  final String? imageUrl;
  final int order;
  final String? url;
  final List<String> images;
  final List<String> stack;
  final String? link;

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      categoryColor: _parseColor(json['category_color'] as String? ?? '#2864E8'),
      imageUrl: json['image_url'] as String?,
      order: json['order'] as int? ?? 0,
      url: json['url'] as String?,
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      stack: (json['stack'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      link: json['link'] as String?,
    );
  }

  static Color _parseColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
