
// -----------------------------------------------------------------
// 1. State class holding all mutable data (like your private fields)
// -----------------------------------------------------------------
import 'package:mosip_pre_registration_mobile/models/document_type_model.dart';
import 'package:mosip_pre_registration_mobile/models/file_model.dart';
import 'package:mosip_pre_registration_mobile/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationState {
  final List<UserModel> users;
  final String? loginId;
  final String? regCenterId;
  final String sameAs;
  final List<DocumentTypeModel>? documentCategories;

  RegistrationState({
    this.users = const [],
    this.loginId,
    this.regCenterId,
    this.sameAs = '',
    this.documentCategories,
  });

  RegistrationState copyWith({
    List<UserModel>? users,
    String? loginId,
    String? regCenterId,
    String? sameAs,
    List<DocumentTypeModel>? documentCategories,
    bool clearLoginId = false,
    bool clearRegCenterId = false,
  }) {
    return RegistrationState(
      users: users ?? this.users,
      loginId: clearLoginId ? null : (loginId ?? this.loginId),
      regCenterId: clearRegCenterId ? null : (regCenterId ?? this.regCenterId),
      sameAs: sameAs ?? this.sameAs,
      documentCategories: documentCategories ?? this.documentCategories,
    );
  }
}

// -----------------------------------------------------------------
// 2. StateNotifier — equivalent to your RegistrationService class
// -----------------------------------------------------------------
class RegistrationService extends StateNotifier<RegistrationState> {
  RegistrationService() : super(RegistrationState());

  // --- Login ID ---
  void setLoginId(String id) {
    state = state.copyWith(loginId: id);
  }

  String? getLoginId() => state.loginId;

  // --- Registration Center ID ---
  void setRegCenterId(String id) {
    state = state.copyWith(regCenterId: id);
  }

  String? getRegCenterId() => state.regCenterId;

  // --- Same As (e.g., "Full Name" copied from another field) ---
  void setSameAs(String value) {
    state = state.copyWith(sameAs: value);
  }

  String getSameAs() => state.sameAs;

  // --- Document Categories ---
  void setDocumentCategories(List<DocumentTypeModel> categories) {
    state = state.copyWith(documentCategories: categories);
  }

  List<DocumentTypeModel>? getDocumentCategories() => state.documentCategories;

  // --- Users Management ---
  void addUser(UserModel user) {
    final updated = [...state.users, user];
    state = state.copyWith(users: updated);
  }

  void addUsers(List<UserModel> users) {
    state = state.copyWith(users: users);
  }

  void updateUser(int index, UserModel newUser) {
    if (index < 0 || index >= state.users.length) return;
    final updated = List<UserModel>.from(state.users);
    updated[index] = newUser;
    state = state.copyWith(users: updated);
  }

  void deleteUser(int index) {
    if (index < 0 || index >= state.users.length) return;
    final updated = List<UserModel>.from(state.users)..removeAt(index);
    state = state.copyWith(users: updated);
  }

  UserModel? getUser(int index) {
    if (index < 0 || index >= state.users.length) return null;
    return state.users[index];
  }

  List<UserModel> getUsers() => List.unmodifiable(state.users);

  List<FileModel>? getUserFiles(int index) {
    return getUser(index)?.files?.documentsMetaData;
  }

  void flushUsers() {
    state = state.copyWith(users: []);
  }

  // Optional: full reset (e.g., on logout)
  void reset() {
    state = RegistrationState();
  }
}

// -----------------------------------------------------------------
// 3. Provider — global access (equivalent to @Injectable providedIn: 'root')
// -----------------------------------------------------------------
final registrationServiceProvider =
    StateNotifierProvider<RegistrationService, RegistrationState>((ref) {
  return RegistrationService();
});