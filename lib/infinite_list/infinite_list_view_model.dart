import 'package:flutter/foundation.dart';

import 'package:oivan_project/infinite_list/infinite_list_model.dart';

const kDefaultPageSize = 30;

const kFirstPage = 1;

abstract class InfiniteListViewModel<T extends Object>
    extends ValueNotifier<ListingModel<T>> {
  InfiniteListViewModel({
    ListingModel<T>? initialBaseCalenderModelState,
    this.pageSize = kDefaultPageSize,
  }) : super(
          initialBaseCalenderModelState ??
              ListingModel<T>(
                items: const [],
                listState: ListState.initial,
                isRefreshing: false,
              ),
        );

  final int pageSize;

  int _pageNumber = kFirstPage;
  int get pageNumber => _pageNumber;

  @protected
  void setState(ListingModel<T> newState) {
    value = newState;
  }

  ListingModel<T> get state => value;

  bool get _isBusy =>
      value.isRefreshing || value.listState == ListState.loading;

  bool get _hasNoMorePages => value.listState == ListState.noMorePages;

  Future<bool> init() async {
    if (_isBusy) return false;
    value = ListingModel<T>(
      items: const [],
      listState: ListState.loading,
      isRefreshing: false,
    );
    final data = await _getItems(kFirstPage, pageSize);

    if (data == null) return false;

    if (data.isEmpty || data.length < kDefaultPageSize) {
      value = value.copyWith(
        listState: ListState.noMorePages,
        items: data,
        isRefreshing: false,
      );
      _pageNumber = kFirstPage + 1;
      return true;
    }
    value = value.copyWith(
      listState: ListState.loaded,
      items: data,
    );
    _pageNumber = kFirstPage + 1;
    return true;
  }

  Future<void> loadMore() async {
    if (_isBusy || _hasNoMorePages) return;

    value = value.copyWith(listState: ListState.loading);
    final data = await _getItems(_pageNumber, pageSize);
    if (data == null) return;

    if (data.isEmpty || data.length < kDefaultPageSize) {
      var newData = value.items;
      if (data.isNotEmpty) newData = [...newData, ...data];

      value = value.copyWith(
        listState: ListState.noMorePages,
        items: newData,
      );
      _pageNumber++;

      return;
    }

    final newData = [...value.items, ...data];
    value = value.copyWith(
      listState: ListState.loaded,
      items: newData,
    );

    _pageNumber++;
  }

  Future<bool> refresh() async {
    if (_isBusy) return false;

    value = value.copyWith(isRefreshing: true);

    var currentPageNumber = _pageNumber - 1;
    if (currentPageNumber == 0) currentPageNumber = kFirstPage;

    final loadedPagesSize = pageSize * currentPageNumber;

    try {
      final data = await fetchData(kFirstPage, loadedPagesSize);
      value = ListingModel(
        listState: data.length < loadedPagesSize
            ? ListState.noMorePages
            : ListState.loaded,
        items: data,
        isRefreshing: false,
      );
      return true;
    } on Exception catch (e, s) {
      value = value.copyWith(isRefreshing: false);
      return false;
    }
  }

  Future<List<T>?> _getItems(int pageNumber, int pageSize) async {
    try {
      final result = await fetchData(pageNumber, pageSize);
      final value = result;
      return value;
    } on Exception catch (e, s) {
      value = value.copyWith(listState: ListState.error);
      return null;
    }
  }

  @protected
  Future<List<T>> fetchData(
    int pageNumber,
    int pageSize,
  );
}
