import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oivan_project/data/user.dart';
import 'package:oivan_project/infinite_list/infinite_list_view_model.dart';
import 'package:oivan_project/service/global_event_bus.dart';
import 'package:oivan_project/service/user_book_marks_storage.dart';

final userBookMarksViewModelProvider = Provider.autoDispose((ref) {
  return UserBookMarksViewModel(
    ref.watch(userBookMarksStorageStorage),
  );
});

class UserBookMarksViewModel extends InfiniteListViewModel<User> {
  final UserBookMarksStorage _storage;

  UserBookMarksViewModel(
    this._storage,
  );

  Future<bool> deleteBookMark(int userId) async {
    final isOk = await _storage.deleteUser(userId);

    if (isOk) {
      GlobalEventBus.sendEvent(
        name: GlobalEvent.bookMarkDeleted.name,
        sender: this,
        payload: {'id': userId},
      );
      refresh();
    }

    return isOk;
  }

  @override
  Future<List<User>> fetchData(int pageNumber, int pageSize) async {
    final users = await _storage.getUsers(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    return users;
  }
}
