import 'package:ondo/domain/repositories/search/search_repository.dart';

class LoadSearchKeywordListUseCase {
  final SearchRepository repository;

  LoadSearchKeywordListUseCase({required this.repository});

  Future<List<String>> call() async {
    return await repository.getSearchKeywordList();
  }
}
