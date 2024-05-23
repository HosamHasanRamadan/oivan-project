import 'dart:convert';

typedef FromMapT<T> = T Function(Map<String, dynamic> mapT);
typedef ToJsonT<T> = Map<String, dynamic> Function(T object);

class BaseListResponse<T extends Object> {
  final List<T> items;
  final bool hasMore;
  final int quotaMax;
  final int quotaRemaining;

  BaseListResponse({
    required this.items,
    required this.hasMore,
    required this.quotaMax,
    required this.quotaRemaining,
  });

  Map<String, dynamic> toMap(ToJsonT<T> toJsonT) => {
        'items': items.map((x) => toJsonT(x)).toList(),
        'has_more': hasMore,
        'quota_max': quotaMax,
        'quota_remaining': quotaRemaining,
      };

  factory BaseListResponse.fromMap(
    Map<String, dynamic> map,
    FromMapT<T> formMapT,
  ) {
    return BaseListResponse<T>(
      items: List<T>.from(map['items']?.map((x) => formMapT(x))),
      hasMore: map['has_more'] ?? false,
      quotaMax: map['quota_max']?.toInt() ?? 0,
      quotaRemaining: map['quota_remaining']?.toInt() ?? 0,
    );
  }

  String toJson(ToJsonT<T> toJsonT) => json.encode(toMap(toJsonT));

  factory BaseListResponse.fromJson(String source, FromMapT<T> fromMapT) =>
      BaseListResponse.fromMap(
        json.decode(source),
        fromMapT,
      );
}
