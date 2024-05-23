import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oivan_project/data/base_list_response.dart';
import 'package:oivan_project/data/reputation_history.dart';
import 'package:oivan_project/data/user.dart';

final userRepositoryProvider = Provider((ref) => UserRepository(Dio()));

class UserRepository {
  final Dio _httpClient;
  UserRepository(this._httpClient);

  final _basePath = 'https://api.stackexchange.com/2.2/users';
  final headers = {
    'Accept': 'application/json;charset=utf-8',
    'Accept-Language': 'en'
  };

  Future<BaseListResponse<User>> getUsers({
    required int pageNumber,
    required int pageSize,
  }) async {
    final url =
        '$_basePath?page=$pageNumber&pagesize=$pageSize&site=stackoverflow';
    final response = await _httpClient.get<Map<String, dynamic>>(
      url,
      options: Options(headers: headers),
    );

    return BaseListResponse.fromMap(
      response.data!,
      User.fromMap,
    );
  }

  Future<BaseListResponse<ReputationHistory>> getUserReputationHistory({
    required int pageNumber,
    required int pageSize,
    required int userId,
  }) async {
    final url =
        '$_basePath/$userId/reputation-history?page=$pageNumber&pagesize=$pageSize&site=stackoverflow';

    final response = await _httpClient.get<Map<String, dynamic>>(
      url,
      options: Options(headers: headers),
    );

    return BaseListResponse.fromMap(
      response.data!,
      ReputationHistory.fromMap,
    );
  }

  Future<BaseListResponse<User>> getUsersBy({
    int pageNumber = 1,
    int pageSize = 30,
    required List<int> ids,
  }) async {
    final urlIDs = ids.join(';');

    final url =
        '$_basePath/$urlIDs?page=$pageNumber&pagesize=$pageSize&site=stackoverflow';

    final response = await _httpClient.get<Map<String, dynamic>>(url);

    return BaseListResponse.fromMap(
      response.data!,
      User.fromMap,
    );
  }
}
