import 'package:ondo/domain/repositories/search/search_repository.dart';

class SaveSearchKeywordUseCase {
  final SearchRepository repository;

  SaveSearchKeywordUseCase({required this.repository});

  Future<bool> call(String keyword) async {
    return await repository.saveSearchKeyword(keyword);
  }
}
