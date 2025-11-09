class ApiResponse<T> {
  final T data;
  final dynamic meta;
  final dynamic links;

  ApiResponse({
    required this.data,
    this.meta,
    this.links,
  });

    factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      data: fromJsonT(json['data']),
      meta: json['meta'],
      links: json['links'],
    );
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return {
      'data': toJsonT(data),
      'meta': meta,
      'links': links,
    };
  }
}