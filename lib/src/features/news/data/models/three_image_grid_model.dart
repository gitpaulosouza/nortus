class ThreeImageGridModel {
  final String topImageUrl;
  final String bottomLeftImageUrl;
  final String bottomRightImageUrl;
  final String caption;

  const ThreeImageGridModel({
    required this.topImageUrl,
    required this.bottomLeftImageUrl,
    required this.bottomRightImageUrl,
    required this.caption,
  });

  static ThreeImageGridModel fromJson(Map<String, dynamic> json) {
    return ThreeImageGridModel(
      topImageUrl: json['topImageUrl'] as String? ?? '',
      bottomLeftImageUrl: json['bottomLeftImageUrl'] as String? ?? '',
      bottomRightImageUrl: json['bottomRightImageUrl'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topImageUrl': topImageUrl,
      'bottomLeftImageUrl': bottomLeftImageUrl,
      'bottomRightImageUrl': bottomRightImageUrl,
      'caption': caption,
    };
  }
}
