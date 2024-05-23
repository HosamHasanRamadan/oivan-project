import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oivan_project/data/base_list_response.dart';
import 'package:oivan_project/data/user.dart';
import 'package:oivan_project/repository/user_repository.dart';
import 'package:oivan_project/service/user_book_marks_storage.dart';
import 'package:oivan_project/view_model/users_view_model.dart';

class UserRepositoryMock extends Mock implements UserRepository {}

class UserBookMarksStorageMock extends Mock implements UserBookMarksStorage {}

void main() {
  late UserRepository userRepo;
  late UserBookMarksStorageMock userBookMarkStorage;
  late UsersViewModel vm;
  setUp(() {
    registerFallbackValue(
      User(
        reputation: 123123,
        userId: 43645,
        location: 'Egypt',
        profileImage: 'https://www.google.com',
        displayName: 'Hosam Hasan',
      ),
    );
    userRepo = UserRepositoryMock();
    userBookMarkStorage = UserBookMarksStorageMock();
    vm = UsersViewModel(
      userRepo,
      userBookMarkStorage,
    );
  });
  tearDown(() {
    vm.dispose();
  });

  test("Load users with bookmarks", () async {
    final users = [
      User(
        reputation: 123123,
        userId: 43645,
        location: 'Egypt',
        profileImage: 'https://www.google.com',
        displayName: 'Hosam Hasan',
      ),
      User(
        reputation: 4534,
        userId: 21125,
        location: 'Egypt',
        profileImage: 'https://www.google.com',
        displayName: 'Omar Foly',
      ),
    ];
    final response = BaseListResponse(
      items: users,
      hasMore: false,
      quotaMax: 1000,
      quotaRemaining: 900,
    );
    when(
      () => userRepo.getUsers(
        pageNumber: 1,
        pageSize: 30,
      ),
    ).thenAnswer((_) => Future.value(response));

    when(
      () => userBookMarkStorage.addUser(any<User>()),
    ).thenAnswer(
      (invocation) => Future.value(true),
    );

    when(
      () => userBookMarkStorage.containsKey(any<int>()),
    ).thenAnswer(
      (invocation) => true,
    );
    await vm.init();

    expect(vm.value.items[0].isBookMarked, true);
    expect(vm.value.items[1].isBookMarked, true);
  });
  test("Add Bookmark", () async {
    final users = [
      User(
        reputation: 123123,
        userId: 43645,
        location: 'Egypt',
        profileImage: 'https://www.google.com',
        displayName: 'Hosam Hasan',
      ),
      User(
        reputation: 4534,
        userId: 21125,
        location: 'Egypt',
        profileImage: 'https://www.google.com',
        displayName: 'Omar Foly',
      ),
    ];
    final response = BaseListResponse(
      items: users,
      hasMore: false,
      quotaMax: 1000,
      quotaRemaining: 900,
    );
    when(
      () => userRepo.getUsers(
        pageNumber: 1,
        pageSize: 30,
      ),
    ).thenAnswer((_) => Future.value(response));

    when(
      () => userBookMarkStorage.addUser(any<User>()),
    ).thenAnswer(
      (invocation) => Future.value(true),
    );

    when(
      () => userBookMarkStorage.containsKey(any<int>()),
    ).thenAnswer(
      (invocation) => false,
    );
    await vm.init();
    final userWithBookMark = vm.value.items[0];
    await vm.addBookMark(userWithBookMark.user);

    expect(vm.value.items[0].isBookMarked, true);
  });

  test("Add Bookmark", () async {
    final users = [
      User(
        reputation: 123123,
        userId: 43645,
        location: 'Egypt',
        profileImage: 'https://www.google.com',
        displayName: 'Hosam Hasan',
      ),
      User(
        reputation: 4534,
        userId: 21125,
        location: 'Egypt',
        profileImage: 'https://www.google.com',
        displayName: 'Omar Foly',
      ),
    ];
    final response = BaseListResponse(
      items: users,
      hasMore: false,
      quotaMax: 1000,
      quotaRemaining: 900,
    );
    when(
      () => userRepo.getUsers(
        pageNumber: 1,
        pageSize: 30,
      ),
    ).thenAnswer((_) => Future.value(response));

    when(
      () => userBookMarkStorage.deleteUser(any<int>()),
    ).thenAnswer(
      (invocation) => Future.value(true),
    );

    when(
      () => userBookMarkStorage.containsKey(any<int>()),
    ).thenAnswer(
      (invocation) => true,
    );
    await vm.init();
    final userWithBookMark = vm.value.items[0];
    await vm.deleteBookMark(userWithBookMark.user);

    expect(vm.value.items[0].isBookMarked, false);
  });
}
