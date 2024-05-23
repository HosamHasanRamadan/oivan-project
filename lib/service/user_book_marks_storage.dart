import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oivan_project/data/user.dart';
import 'package:oivan_project/service/local_storage.dart';
import 'package:sembast/sembast.dart';

final userBookMarksStorageStorage = Provider((ref) {
  return UserBookMarksStorage(ref.watch(localStorageProvider));
});

class UserBookMarksStorage {
  static const storeKey = 'user_book_marks';
  final LocalStorage _localStore;
  late final StoreRef<int, Map<String, dynamic>> _storeRef;

  UserBookMarksStorage(
    this._localStore,
  ) {
    _storeRef = intMapStoreFactory.store(storeKey);
  }

  Future<bool> addUser(User user) async {
    final result = await _storeRef
        .record(user.userId)
        .add(_localStore.database, user.toMap());
    if (result == null) return false;
    return true;
  }

  Future<void> updateUser(User user) async {
    await _storeRef.record(user.userId).put(_localStore.database, user.toMap());
  }

  Future<bool> deleteUser(int userId) async {
    final result = await _storeRef.record(userId).delete(
          _localStore.database,
        );
    if (result == null) return false;
    return true;
  }

  Future<User?> getUser(int userId) async {
    final result = await _storeRef.record(userId).get(
          _localStore.database,
        );
    if (result == null) return null;
    return User.fromMap(result);
  }

  Future<List<User>> getUsers({
    required int pageNumber,
    required int pageSize,
  }) async {
    final offset = (pageNumber - 1) * pageSize;
    final limit = pageSize;

    final result = await _storeRef
        .query(
          finder: Finder(
            offset: offset,
            limit: limit,
          ),
        )
        .getSnapshots(_localStore.database);

    return result.map((e) {
      return User.fromMap(e.value);
    }).toList();
  }

  Future<List<int>> getAllUsersKeys() async {
    return await _storeRef.findKeys(_localStore.database);
  }

  bool containsKey(int key) {
    return _storeRef.record(key).getSync(_localStore.database) != null;
  }
}
