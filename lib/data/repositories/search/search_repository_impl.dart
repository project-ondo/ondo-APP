import 'package:ondo/data/datasource/search/search_local_data_source.dart';
import 'package:ondo/domain/repositories/search/search_repository.dart';

class SearchRepositoryImpl extends SearchRepository {
  final SearchLocalDataSource localDataSource;

  SearchRepositoryImpl({required this.localDataSource});

  @override
  Future<List<String>> getSearchKeywordList() async {
    return await localDataSource.getSearchKeywordList();
  }

  @override
  Future<bool> saveSearchKeyword(String keyword) {
    return localDataSource.saveSearchKeyword(keyword);
  }
}
