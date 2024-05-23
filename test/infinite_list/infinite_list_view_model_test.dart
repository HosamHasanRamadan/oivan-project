import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oivan_project/infinite_list/infinite_list_model.dart';
import 'package:oivan_project/infinite_list/infinite_list_view_model.dart';

abstract class IntRepo {
  Future<List<int>> getIntegers(int pageNumber, int pageSize);
}

class FakeIntGeneratorRepo extends Mock implements IntRepo {}

class ViewModel extends InfiniteListViewModel<int> {
  IntRepo intRepo;
  ViewModel(this.intRepo);
  @override
  Future<List<int>> fetchData(int pageNumber, int pageSize) {
    return intRepo.getIntegers(pageNumber, pageSize);
  }
}

void main() {
  late FakeIntGeneratorRepo mockRepo;
  late ViewModel vm;
  final changeStack = <ListingModel<int>>[];
  onChange() {
    changeStack.add(vm.value);
  }

  setUp(() {
    mockRepo = FakeIntGeneratorRepo();
    vm = ViewModel(mockRepo);

    vm.addListener(onChange);
  });
  tearDown(() {
    changeStack.clear();
    vm.removeListener(onChange);
    vm.dispose();
  });

  test('verify initial state', () {
    expect(
      vm.value,
      const ListingModel<int>(
        items: [],
        listState: ListState.initial,
        isRefreshing: false,
      ),
    );

    expect(
      vm.pageNumber,
      1,
    );
  });
  group('verify init method', () {
    test('verify init method on Exception', () async {
      when(() {
        return mockRepo.getIntegers(1, 30);
      }).thenThrow(Exception('Error while loading data'));

      await vm.init();

      expect(
        changeStack,
        [
          const ListingModel<int>(
            items: [],
            listState: ListState.loading,
            isRefreshing: false,
          ),
          const ListingModel<int>(
            items: <int>[],
            listState: ListState.error,
            isRefreshing: false,
          ),
        ],
      );
    });

    test('init success with result size < pageSize', () async {
      final values = List.generate(5, (index) => index);
      when(() => mockRepo.getIntegers(1, 30)).thenAnswer(
        (_) => Future.value(
          values,
        ),
      );

      await vm.init();

      // test
      expect(
        changeStack,
        [
          const ListingModel<int>(
            items: [],
            listState: ListState.loading,
            isRefreshing: false,
          ),
          ListingModel<int>(
            items: values,
            listState: ListState.noMorePages,
            isRefreshing: false,
          ),
        ],
      );

      expect(
        vm.pageNumber,
        2,
      );
    });

    test('init success with result size == pageSize', () async {
      final values = List.generate(30, (index) => index);
      when(() => mockRepo.getIntegers(1, 30)).thenAnswer(
        (_) => Future.value(
          values,
        ),
      );

      await vm.init();

      expect(
        changeStack,
        [
          const ListingModel<int>(
            items: [],
            listState: ListState.loading,
            isRefreshing: false,
          ),
          ListingModel<int>(
            items: values,
            listState: ListState.loaded,
            isRefreshing: false,
          ),
        ],
      );

      expect(
        vm.pageNumber,
        2,
      );
    });
  });

  group('Loading more data result size == pageSize', () {
    test(
      'Loading more data',
      () async {
        final values = List.generate(30, (index) => index);
        when(() => mockRepo.getIntegers(1, 30)).thenAnswer(
          (_) {
            return Future.value(
              values,
            );
          },
        );
        await vm.loadMore();

        expect(
          changeStack,
          [
            const ListingModel<int>(
              items: <int>[],
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: values,
              listState: ListState.loaded,
              isRefreshing: false,
            ),
          ],
        );

        expect(
          vm.pageNumber,
          2,
        );
      },
    );
    test(
      'Loading more data with result < pageSize',
      () async {
        final values = List.generate(20, (index) => index);
        when(() => mockRepo.getIntegers(1, 30)).thenAnswer(
          (_) {
            return Future.value(
              values,
            );
          },
        );

        await vm.loadMore();

        expect(
          changeStack,
          [
            const ListingModel<int>(
              items: <int>[],
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: values,
              listState: ListState.noMorePages,
              isRefreshing: false,
            ),
          ],
        );

        expect(
          vm.pageNumber,
          2,
        );
      },
    );

    test(
      'Error while loading more date',
      () async {
        when(() => mockRepo.getIntegers(1, 30))
            .thenThrow(Exception('Error while loading data'));

        await vm.loadMore();

        expect(
          changeStack,
          [
            const ListingModel<int>(
              items: <int>[],
              listState: ListState.loading,
              isRefreshing: false,
            ),
            const ListingModel<int>(
              items: [],
              listState: ListState.error,
              isRefreshing: false,
            ),
          ],
        );

        expect(
          vm.pageNumber,
          1,
        );
      },
    );

    test(
      'Load more data twice',
      () async {
        final value1 = List.generate(
          30,
          (index) => index,
        );
        final value2 = List.generate(
          30,
          (index) => index * 2,
        );
        when(() => mockRepo.getIntegers(1, 30))
            .thenAnswer((_) => Future.value(value1));
        when(() => mockRepo.getIntegers(2, 30))
            .thenAnswer((_) => Future.value(value2));

        await vm.loadMore();
        await vm.loadMore();

        expect(
          changeStack,
          [
            const ListingModel<int>(
              items: <int>[],
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loaded,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: [...value1, ...value2],
              listState: ListState.loaded,
              isRefreshing: false,
            ),
          ],
        );

        expect(
          vm.pageNumber,
          3,
        );
      },
    );

    test(
      'Load more data twice with second result size < page Size ',
      () async {
        final value1 = List.generate(
          30,
          (index) => index,
        );
        final value2 = List.generate(
          20,
          (index) => index * 2,
        );
        when(() => mockRepo.getIntegers(1, 30))
            .thenAnswer((_) => Future.value(value1));
        when(() => mockRepo.getIntegers(2, 30))
            .thenAnswer((_) => Future.value(value2));

        await vm.loadMore();
        await vm.loadMore();

        expect(
          changeStack,
          [
            const ListingModel<int>(
              items: <int>[],
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loaded,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: [...value1, ...value2],
              listState: ListState.noMorePages,
              isRefreshing: false,
            ),
          ],
        );

        expect(
          vm.pageNumber,
          3,
        );
      },
    );

    test(
      'Load more after init ',
      () async {
        final value1 = List.generate(
          30,
          (index) => index,
        );
        final value2 = List.generate(
          30,
          (index) => index * 2,
        );
        when(() => mockRepo.getIntegers(1, 30))
            .thenAnswer((_) => Future.value(value1));
        when(() => mockRepo.getIntegers(2, 30))
            .thenAnswer((_) => Future.value(value2));

        await vm.init();
        await vm.loadMore();

        expect(
          changeStack,
          [
            const ListingModel<int>(
              items: <int>[],
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loaded,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: [...value1, ...value2],
              listState: ListState.loaded,
              isRefreshing: false,
            ),
          ],
        );

        expect(
          vm.pageNumber,
          3,
        );
      },
    );

    test(
      'Load more after init with result size <  page size',
      () async {
        final value1 = List.generate(
          30,
          (index) => index,
        );
        final value2 = List.generate(
          20,
          (index) => index * 2,
        );
        when(() => mockRepo.getIntegers(1, 30))
            .thenAnswer((_) => Future.value(value1));
        when(() => mockRepo.getIntegers(2, 30))
            .thenAnswer((_) => Future.value(value2));

        await vm.init();
        await vm.loadMore();

        expect(
          changeStack,
          [
            const ListingModel<int>(
              items: <int>[],
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loaded,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: [...value1, ...value2],
              listState: ListState.noMorePages,
              isRefreshing: false,
            ),
          ],
        );

        expect(
          vm.pageNumber,
          3,
        );
      },
    );

    test(
      'Stop loading more data if reach max',
      () async {
        final value1 = List.generate(
          30,
          (index) => index,
        );
        final value2 = List.generate(
          20,
          (index) => index * 2,
        );
        when(() => mockRepo.getIntegers(1, 30))
            .thenAnswer((_) => Future.value(value1));
        when(() => mockRepo.getIntegers(2, 30))
            .thenAnswer((_) => Future.value(value2));

        await vm.init();
        await vm.loadMore();

        // extra load more when
        // shouldn't load more data
        await vm.loadMore();

        expect(
          changeStack,
          [
            const ListingModel<int>(
              items: <int>[],
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loaded,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: [...value1, ...value2],
              listState: ListState.noMorePages,
              isRefreshing: false,
            ),
          ],
        );

        expect(
          vm.pageNumber,
          3,
        );
      },
    );

    test(
      'Error while loading more data while having data loaded before',
      () async {
        final value1 = List.generate(
          30,
          (index) => index,
        );
        final value2 = List.generate(
          30,
          (index) => index * 2,
        );
        when(() => mockRepo.getIntegers(1, 30))
            .thenAnswer((_) => Future.value(value1));

        when(() => mockRepo.getIntegers(2, 30))
            .thenAnswer((_) => Future.value(value2));

        when(() => mockRepo.getIntegers(3, 30))
            .thenThrow(Exception("Can't load more data"));

        await vm.init();
        await vm.loadMore();
        await vm.loadMore();

        expect(
          changeStack,
          [
            const ListingModel<int>(
              items: <int>[],
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loaded,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: [...value1, ...value2],
              listState: ListState.loaded,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: [...value1, ...value2],
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: [...value1, ...value2],
              listState: ListState.error,
              isRefreshing: false,
            ),
          ],
        );

        expect(
          vm.pageNumber,
          3,
        );
      },
    );

    test(
      'Load more data after error',
      () async {
        final value1 = List.generate(
          30,
          (index) => index,
        );
        final value2 = List.generate(
          30,
          (index) => index * 2,
        );
        when(() => mockRepo.getIntegers(1, 30))
            .thenAnswer((_) => Future.value(value1));

        when(() => mockRepo.getIntegers(2, 30))
            .thenThrow(Exception("Can't load more data"));

        await vm.init();
        await vm.loadMore();

        /// override  exception
        when(() => mockRepo.getIntegers(2, 30))
            .thenAnswer((_) => Future.value(value2));

        await vm.loadMore();

        expect(
          changeStack,
          [
            const ListingModel<int>(
              items: <int>[],
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loaded,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.error,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: value1,
              listState: ListState.loading,
              isRefreshing: false,
            ),
            ListingModel<int>(
              items: [...value1, ...value2],
              listState: ListState.loaded,
              isRefreshing: false,
            ),
          ],
        );

        expect(
          vm.pageNumber,
          3,
        );
      },
    );
  });

  group('Refresh data', () {
    test(
        'Refresh current data when loaded data size < page size even after refresh',
        () async {
      final values1 = List.generate(20, (index) => index);
      final values2 = List.generate(25, (index) => index);
      when(() => mockRepo.getIntegers(1, 30)).thenAnswer(
        (_) {
          return Future.value(
            values1,
          );
        },
      );
      await vm.init();

      when(() => mockRepo.getIntegers(1, 30)).thenAnswer(
        (_) => Future.value(values2),
      );
      await vm.refresh();

      expect(
        changeStack,
        [
          const ListingModel<int>(
            items: <int>[],
            listState: ListState.loading,
            isRefreshing: false,
          ),
          ListingModel<int>(
            items: values1,
            listState: ListState.noMorePages,
            isRefreshing: false,
          ),
          ListingModel<int>(
            items: values1,
            listState: ListState.noMorePages,
            isRefreshing: true,
          ),
          ListingModel<int>(
            items: values2,
            listState: ListState.noMorePages,
            isRefreshing: false,
          ),
        ],
      );

      expect(
        vm.pageNumber,
        2,
      );
    });

    test(
        'Refresh current data when loaded data size < page size and refreshed data == page size',
        () async {
      final values1 = List.generate(20, (index) => index);
      final values2 = List.generate(30, (index) => index);
      when(() => mockRepo.getIntegers(1, 30)).thenAnswer(
        (_) {
          return Future.value(
            values1,
          );
        },
      );
      await vm.init();

      when(() => mockRepo.getIntegers(1, 30)).thenAnswer(
        (_) => Future.value(values2),
      );
      await vm.refresh();

      expect(
        changeStack,
        [
          const ListingModel<int>(
            items: <int>[],
            listState: ListState.loading,
            isRefreshing: false,
          ),
          ListingModel<int>(
            items: values1,
            listState: ListState.noMorePages,
            isRefreshing: false,
          ),
          ListingModel<int>(
            items: values1,
            listState: ListState.noMorePages,
            isRefreshing: true,
          ),
          ListingModel<int>(
            items: values2,
            listState: ListState.loaded,
            isRefreshing: false,
          ),
        ],
      );

      expect(
        vm.pageNumber,
        2,
      );
    });
  });
}
