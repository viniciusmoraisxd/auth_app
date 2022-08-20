import '../../domain/entities/user_entity.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/add_user.dart';
import '../firebase/firebase.dart';
import '../models/models.dart';

class RemoteAddUser implements AddUser {
  final FirebaseDatabaseClient databaseClient;

  RemoteAddUser({required this.databaseClient});
  @override
  Future<void> call({required UserEntity userEntity}) async {
    try {
      final json = RemoteUserModel.fromEntity(userEntity).toJson();

      await databaseClient.save(collection: "users", json: json);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
