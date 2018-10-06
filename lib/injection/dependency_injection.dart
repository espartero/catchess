import '../repository/group_repository.dart';
import '../repository/mock/group_repository_mock.dart';

enum Flavor { MOCK, PRO }

/// Simple dependency injection utility class.
class Injector {
  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;

  GroupRepository _groupRepository;

  Injector._internal();

  factory Injector() {
    return _singleton;
  }

  static void configure(Flavor flavor) {
    _flavor = flavor;

    switch (_flavor) {
      case Flavor.MOCK:
        _singleton._groupRepository = GroupRepositoryMock();
        break;
      default: // Flavor.PRO:
        _singleton._groupRepository = GroupRepositoryMock();
        break;
    }
  }

  GroupRepository get groupRepository {
    return this._groupRepository;
  }
}
