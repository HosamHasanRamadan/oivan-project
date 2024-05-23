import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oivan_project/data/reputation_history.dart';
import 'package:oivan_project/infinite_list/infinite_list_view_model.dart';
import 'package:oivan_project/repository/user_repository.dart';

final userReputationHistoryViewModelProvider =
    Provider.autoDispose.family<UserReputationHistoryViewModel, int>(
  (ref, int userId) {
    return UserReputationHistoryViewModel(
      ref.watch(userRepositoryProvider),
      userId,
    );
  },
);

class UserReputationHistoryViewModel
    extends InfiniteListViewModel<ReputationHistory> {
  final UserRepository _userRepository;
  final int _userId;

  UserReputationHistoryViewModel(
    this._userRepository,
    this._userId,
  );
  @override
  Future<List<ReputationHistory>> fetchData(
    int pageNumber,
    int pageSize,
  ) async {
    final users = await _userRepository.getUserReputationHistory(
      pageNumber: pageNumber,
      pageSize: pageSize,
      userId: _userId,
    );
    return users.items;
  }
}
