class ContentImageModel {
  final String imageUrl;
  final String caption;

  const ContentImageModel({
    required this.imageUrl,
    required this.caption,
  });

  factory ContentImageModel.fromJson(Map<String, dynamic> json) {
    return ContentImageModel(
      imageUrl: json['imageUrl'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'caption': caption,
    };
  }
}
