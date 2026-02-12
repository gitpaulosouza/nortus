import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';

class UserState {
  final UserModel? user;
  final UserModel? draft;
  final bool isLoading;
  final bool isSaving;
  final AppError? error;
  final bool hasUnsavedChanges;
  final bool saveSuccess;

  const UserState({
    this.user,
    this.draft,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.hasUnsavedChanges = false,
    this.saveSuccess = false,
  });

  factory UserState.initial() {
    return const UserState();
  }

  UserState copyWith({
    UserModel? user,
    UserModel? draft,
    bool? isLoading,
    bool? isSaving,
    AppError? error,
    bool? hasUnsavedChanges,
    bool? saveSuccess,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return UserState(
      user: user ?? this.user,
      draft: draft ?? this.draft,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      saveSuccess: clearSuccess ? false : (saveSuccess ?? this.saveSuccess),
    );
  }
}
