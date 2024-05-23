import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oivan_project/data/user.dart';
import 'package:oivan_project/infinite_list/infinite_list_view_model.dart';
import 'package:oivan_project/repository/user_repository.dart';
import 'package:oivan_project/service/global_event_bus.dart';
import 'package:oivan_project/service/user_book_marks_storage.dart';

final userViewModelProvider = Provider.autoDispose(
  (ref) {
    final vm = UsersViewModel(
      ref.watch(userRepositoryProvider),
      ref.watch(userBookMarksStorageStorage),
    );

    ref.onDispose(vm.dispose);

    return vm;
  },
);

class UsersViewModel extends InfiniteListViewModel<UserWithBookMark> {
  final UserRepository _userRepository;
  final UserBookMarksStorage _userBookMarksStorage;

  late final EventSubscriptionDisposer _onUserBookMarkAddedDisposer;
  late final EventSubscriptionDisposer _onUserBookMarkDeletedDisposer;

  UsersViewModel(
    this._userRepository,
    this._userBookMarksStorage,
  ) {
    _onUserBookMarkAddedDisposer = GlobalEventBus.subscribe(
      receiver: this,
      eventName: GlobalEvent.bookMarkAdded.name,
      onEvent: (event) {
        final id = event?['id'] as int?;
        if (id != null) _addBookMarkLocally(id);
      },
    );

    _onUserBookMarkDeletedDisposer = GlobalEventBus.subscribe(
      receiver: this,
      eventName: GlobalEvent.bookMarkDeleted.name,
      onEvent: (event) {
        final id = event?['id'] as int?;
        if (id != null) _deleteBookMarkLocally(id);
      },
    );
  }

  @override
  Future<List<UserWithBookMark>> fetchData(int pageNumber, int pageSize) async {
    final users = await _userRepository.getUsers(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    return users.items.map((user) {
      return UserWithBookMark(
        isBookMarked: _isBookMarked(user.userId),
        user: user,
      );
    }).toList();
  }

  Future<void> addBookMark(User user) async {
    final isOk = await _userBookMarksStorage.addUser(user);
    if (isOk) _addBookMarkLocally(user.userId);
  }

  Future<void> deleteBookMark(User user) async {
    final isOk = await _userBookMarksStorage.deleteUser(user.userId);
    if (isOk) _deleteBookMarkLocally(user.userId);
  }

  void _addBookMarkLocally(int userId) {
    final index = value.items.indexWhere(
      (element) => element.user.userId == userId,
    );
    if (index < 0) return;
    final item = value.items[index];
    final newList = [...value.items];
    newList[index] = item.copyWith(isBookMarked: true);
    value = value.copyWith(items: newList);
  }

  void _deleteBookMarkLocally(int userId) {
    final index = value.items.indexWhere(
      (element) => element.user.userId == userId,
    );
    if (index < 0) return;
    final item = value.items[index];
    final newList = [...value.items];
    newList[index] = item.copyWith(isBookMarked: false);
    value = value.copyWith(items: newList);
  }

  bool _isBookMarked(int id) {
    return _userBookMarksStorage.containsKey(id);
  }

  @override
  void dispose() {
    _onUserBookMarkAddedDisposer();
    _onUserBookMarkDeletedDisposer();
    super.dispose();
  }
}

class UserWithBookMark {
  final User user;
  final bool isBookMarked;
  UserWithBookMark({
    required this.user,
    required this.isBookMarked,
  });

  UserWithBookMark copyWith({
    User? user,
    bool? isBookMarked,
  }) {
    return UserWithBookMark(
      user: user ?? this.user,
      isBookMarked: isBookMarked ?? this.isBookMarked,
    );
  }
}
