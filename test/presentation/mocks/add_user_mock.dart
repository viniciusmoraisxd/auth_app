import 'package:auth_app/domain/entities/entities.dart';
import 'package:auth_app/domain/helpers/helpers.dart';
import 'package:auth_app/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

class AddUserSpy extends Mock implements AddUser {
  When mockAddUserCall() =>
      when(() => call(userEntity: any(named: "userEntity")));

  void mockAddUserResponse() => mockAddUserCall().thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return _;
      });

  void mockAddUserResponseError(DomainError error) =>
      mockAddUserCall().thenThrow(error);
}

UserEntity makeUser() =>
    UserEntity(name: faker.person.name(), uid: faker.guid.guid());
