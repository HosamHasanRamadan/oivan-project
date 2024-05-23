import 'package:flutter/foundation.dart';

enum ListState {
  /// idle state for list
  initial,

  /// loading state when list is loading first pages or more pages
  loading,

  /// when date is loaded successfully
  loaded,

  /// when loading data ended with error
  error,

  /// when there is no more items to fetch or show
  noMorePages,
}

@immutable
class ListingModel<Item extends Object> {
  final List<Item> items;
  final ListState listState;
  final bool isRefreshing;
  const ListingModel({
    required this.items,
    required this.listState,
    required this.isRefreshing,
  });

  ListingModel<Item> copyWith({
    List<Item>? items,
    ListState? listState,
    bool? isRefreshing,
  }) {
    return ListingModel<Item>(
      items: items ?? this.items,
      listState: listState ?? this.listState,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ListingModel<Item> &&
        listEquals(other.items, items) &&
        other.listState == listState &&
        other.isRefreshing == isRefreshing;
  }

  @override
  int get hashCode =>
      items.hashCode ^ listState.hashCode ^ isRefreshing.hashCode;

  @override
  String toString() =>
      'ListingModel(items: ${items.length}, listState: $listState, isRefreshing: $isRefreshing)';
}
