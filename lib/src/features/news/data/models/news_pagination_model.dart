class NewsPaginationModel {
  final int page;
  final int pageSize;
  final int totalPages;
  final int totalItems;

  const NewsPaginationModel({
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.totalItems,
  });

  factory NewsPaginationModel.fromJson(Map<String, dynamic> json) {
    return NewsPaginationModel(
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 0,
      totalItems: json['totalItems'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'totalPages': totalPages,
      'totalItems': totalItems,
    };
  }
}
