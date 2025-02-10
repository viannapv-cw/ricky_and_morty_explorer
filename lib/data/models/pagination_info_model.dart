class PaginationInfoModel {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  PaginationInfoModel({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  factory PaginationInfoModel.fromJson(Map<String, dynamic> json) {
    return PaginationInfoModel(
      count: json['count'],
      pages: json['pages'],
      next: json['next'],
      prev: json['prev'],
    );
  }
} 