import 'package:ondo/data/datasource/user/profile_remote_datasource.dart';

class DeleteAccountUseCase {
  final ProfileRemoteDatasource profileRemoteDatasource;

  DeleteAccountUseCase({required this.profileRemoteDatasource});

  Future<void> call() {
    return profileRemoteDatasource.deleteAccount();
  }
}