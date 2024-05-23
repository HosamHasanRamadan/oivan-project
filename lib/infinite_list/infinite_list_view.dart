import 'package:flutter/material.dart';
import 'package:oivan_project/infinite_list/infinite_list_model.dart';
import 'package:oivan_project/infinite_list/infinite_list_view_model.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class InfiniteListView<T extends Object> extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final InfiniteListViewModel<T> viewModel;
  final IndexedWidgetBuilder? separatorBuilder;
  final WidgetBuilder? emptyBuilder;
  final WidgetBuilder? errorBuilder;
  final Widget? preList;
  final Widget? endOfList;
  final Axis axis;

  const InfiniteListView({
    super.key,
    required this.itemBuilder,
    required this.viewModel,
    this.preList,
    this.endOfList,
    this.separatorBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.axis = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final state = viewModel.state;
        final list = viewModel.state.items;
        final isLoading = state.listState == ListState.loading;

        int effectiveListLength = list.length;
        if (list.isNotEmpty) {
          if (preList != null) {
            effectiveListLength++;
          }
          if (endOfList != null && state.listState == ListState.noMorePages) {
            effectiveListLength++;
          }
        }

        return InfiniteList(
          scrollDirection: axis,
          onFetchData: () => viewModel.loadMore(),
          separatorBuilder: separatorBuilder,
          isLoading: isLoading,
          itemCount: effectiveListLength,
          itemBuilder: (context, index) {
            if (preList != null && index == 0) return preList!;

            final canShowEndOfList = endOfList != null &&
                state.listState == ListState.noMorePages &&
                index == effectiveListLength - 1;
            if (canShowEndOfList) return endOfList!;

            int effectiveIndex = preList == null ? index : index - 1;
            return itemBuilder(context, effectiveIndex);
          },
          hasError: viewModel.state.listState == ListState.error,
          centerLoading: list.isEmpty,
          centerError: list.isEmpty,
          centerEmpty: list.isEmpty,
          hasReachedMax: viewModel.state.listState == ListState.noMorePages ||
              viewModel.state.listState == ListState.initial,
          emptyBuilder: (context) => _defaultEmptyBuilder(context),
          loadingBuilder: (context) => _defaultLoadingBuilder(),
          errorBuilder: (context) => _defaultErrorBuilder(context),
        );
      },
    );
  }

  Widget _defaultEmptyBuilder(BuildContext context) {
    if (viewModel.state.items.isEmpty && emptyBuilder != null) {
      return emptyBuilder!.call(context);
    }
    return const Center(child: Text('No Date found'));
  }

  Widget _defaultLoadingBuilder() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _defaultErrorBuilder(BuildContext context) {
    if (errorBuilder != null) return errorBuilder!(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: OutlinedButton.icon(
          onPressed: () {
            if (viewModel.state.items.isEmpty) {
              viewModel.init();
              return;
            }
            viewModel.loadMore();
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Try again'),
        ),
      ),
    );
  }
}
