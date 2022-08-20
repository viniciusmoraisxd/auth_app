import '../entities/entities.dart';

abstract class AddUser {
  Future<void> call({required UserEntity userEntity});
}
