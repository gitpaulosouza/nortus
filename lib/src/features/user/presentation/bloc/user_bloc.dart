import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/core/utils/validators.dart';
import 'package:nortus/src/features/user/data/models/adress_user_model.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';
import 'package:nortus/src/features/user/data/repositories/user_repository.dart';
import 'package:nortus/src/features/user/presentation/bloc/user_event.dart';
import 'package:nortus/src/features/user/presentation/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserState.initial()) {
    on<UserStarted>(_onUserStarted);
    on<UserRefreshed>(_onUserRefreshed);
    on<UserNameChanged>(_onUserNameChanged);
    on<UserEmailChanged>(_onUserEmailChanged);
    on<UserLanguageChanged>(_onUserLanguageChanged);
    on<UserDateFormatChanged>(_onUserDateFormatChanged);
    on<UserTimezoneChanged>(_onUserTimezoneChanged);
    on<UserZipCodeChanged>(_onUserZipCodeChanged);
    on<UserCountryChanged>(_onUserCountryChanged);
    on<UserStreetChanged>(_onUserStreetChanged);
    on<UserNumberChanged>(_onUserNumberChanged);
    on<UserComplementChanged>(_onUserComplementChanged);
    on<UserNeighborhoodChanged>(_onUserNeighborhoodChanged);
    on<UserCityChanged>(_onUserCityChanged);
    on<UserStateChanged>(_onUserStateChanged);
    on<UserEditCanceled>(_onUserEditCanceled);
    on<UserSaveRequested>(_onUserSaveRequested);
  }

  Future<void> _onUserStarted(
    UserStarted event,
    Emitter<UserState> emit,
  ) async {
    await _loadUser(emit);
  }

  Future<void> _onUserRefreshed(
    UserRefreshed event,
    Emitter<UserState> emit,
  ) async {
    await _loadUser(emit);
  }

  Future<void> _loadUser(Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));

    final result = await repository.getUser();

    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, error: error));
      },
      (user) {
        emit(
          state.copyWith(
            user: user,
            draft: user,
            isLoading: false,
            hasUnsavedChanges: false,
            clearError: true,
          ),
        );
      },
    );
  }

  void _onUserNameChanged(UserNameChanged event, Emitter<UserState> emit) {
    if (state.draft == null) return;

    final updatedDraft = _copyUserWith(state.draft!, name: event.value);

    emit(
      state.copyWith(
        draft: updatedDraft,
        hasUnsavedChanges: _hasChanges(state.user, updatedDraft),
        clearSuccess: true,
      ),
    );
  }

  void _onUserEmailChanged(UserEmailChanged event, Emitter<UserState> emit) {
    if (state.draft == null) return;

    final updatedDraft = _copyUserWith(state.draft!, email: event.value);

    emit(
      state.copyWith(
        draft: updatedDraft,
        hasUnsavedChanges: _hasChanges(state.user, updatedDraft),
        clearSuccess: true,
      ),
    );
  }

  void _onUserLanguageChanged(
    UserLanguageChanged event,
    Emitter<UserState> emit,
  ) {
    if (state.draft == null) return;

    final updatedDraft = _copyUserWith(state.draft!, language: event.value);

    emit(
      state.copyWith(
        draft: updatedDraft,
        hasUnsavedChanges: _hasChanges(state.user, updatedDraft),
        clearSuccess: true,
      ),
    );
  }

  void _onUserDateFormatChanged(
    UserDateFormatChanged event,
    Emitter<UserState> emit,
  ) {
    if (state.draft == null) return;

    final updatedDraft = _copyUserWith(state.draft!, dateFormat: event.value);

    emit(
      state.copyWith(
        draft: updatedDraft,
        hasUnsavedChanges: _hasChanges(state.user, updatedDraft),
        clearSuccess: true,
      ),
    );
  }

  void _onUserTimezoneChanged(
    UserTimezoneChanged event,
    Emitter<UserState> emit,
  ) {
    if (state.draft == null) return;

    final updatedDraft = _copyUserWith(state.draft!, timezone: event.value);

    emit(
      state.copyWith(
        draft: updatedDraft,
        hasUnsavedChanges: _hasChanges(state.user, updatedDraft),
        clearSuccess: true,
      ),
    );
  }

  void _onUserZipCodeChanged(
    UserZipCodeChanged event,
    Emitter<UserState> emit,
  ) {
    if (state.draft == null) return;

    final updatedAddress = _copyAddressWith(
      state.draft!.address,
      zipCode: event.value,
    );

    final updatedDraft = _copyUserWith(state.draft!, address: updatedAddress);

    emit(
      state.copyWith(
        draft: updatedDraft,
        hasUnsavedChanges: _hasChanges(state.user, updatedDraft),
        clearSuccess: true,
      ),
    );
  }

  void _onUserCountryChanged(
    UserCountryChanged event,
    Emitter<UserState> emit,
  ) {
    if (state.draft == null) return;

    final updatedAddress = _copyAddressWith(
      state.draft!.address,
      country: event.value,
    );

    final updatedDraft = _copyUserWith(state.draft!, address: updatedAddress);

    emit(
      state.copyWith(
        draft: updatedDraft,
        hasUnsavedChanges: _hasChanges(state.user, updatedDraft),
        clearSuccess: true,
      ),
    );
  }

  void _onUserStreetChanged(UserStreetChanged event, Emitter<UserState> emit) {
    if (state.draft == null) return;

    final updatedAddress = _copyAddressWith(
      state.draft!.address,
      street: event.value,
    );

    final updatedDraft = _copyUserWith(state.draft!, address: updatedAddress);

    emit(
      state.copyWith(
        draft: updatedDraft,
        hasUnsavedChanges: _hasChanges(state.user, updatedDraft),
        clearSuccess: true,
      ),
    );
  }

  void _onUserNumberChanged(UserNumberChanged event, Emitter<UserState> emit) {
    if (state.draft == null) return;

    final updatedAddress = _copyAddressWith(
      state.draft!.address,
      number: event.value,
    );

    final updatedDraft = _copyUserWith(state.draft!, address: updatedAddress);

    emit(
      state.copyWith(
        draft: updatedDraft,
        hasUnsavedChanges: _hasChanges(state.user, updatedDraft),
        clearSuccess: true,
      ),
    );
  }

  void _onUserComplementChanged(
    UserComplementChanged event,
    Emitter<UserState> emit,
  ) {
    if (state.draft == null) return;

    final updatedAddress = _copyAddressWith(
      state.draft!.address,
      complement: event.value,
    );

    final updatedDraft = _copyUserWith(state.draft!, address: updatedAddress);

    emit(
      state.copyWith(
        draft: updatedDraft,
        hasUnsavedChanges: _hasChanges(state.user, updatedDraft),
        clearSuccess: true,
      ),
    );
  }

  void _onUserNeighborhoodChanged(
    UserNeighborhoodChanged event,
    Emitter<UserState> emit,
  ) {
    if (state.draft == null) return;

    final updatedAddress = _copyAddressWith(
      state.draft!.address,
      neighborhood: event.value,
    );

    final updatedDraft = _copyUserWith(state.draft!, address: updatedAddress);

    emit(
      state.copyWith(
        draft: updatedDraft,
        hasUnsavedChanges: _hasChanges(state.user, updatedDraft),
        clearSuccess: true,
      ),
    );
  }

  void _onUserCityChanged(UserCityChanged event, Emitter<UserState> emit) {
    if (state.draft == null) return;

    final updatedAddress = _copyAddressWith(
      state.draft!.address,
      city: event.value,
    );

    final updatedDraft = _copyUserWith(state.draft!, address: updatedAddress);

    emit(
      state.copyWith(
        draft: updatedDraft,
        hasUnsavedChanges: _hasChanges(state.user, updatedDraft),
        clearSuccess: true,
      ),
    );
  }

  void _onUserStateChanged(UserStateChanged event, Emitter<UserState> emit) {
    if (state.draft == null) return;

    final updatedAddress = _copyAddressWith(
      state.draft!.address,
      state: event.value,
    );

    final updatedDraft = _copyUserWith(state.draft!, address: updatedAddress);

    emit(
      state.copyWith(
        draft: updatedDraft,
        hasUnsavedChanges: _hasChanges(state.user, updatedDraft),
        clearSuccess: true,
      ),
    );
  }

  void _onUserEditCanceled(UserEditCanceled event, Emitter<UserState> emit) {
    emit(
      state.copyWith(
        draft: state.user,
        hasUnsavedChanges: false,
        clearError: true,
        clearSuccess: true,
      ),
    );
  }

  Future<void> _onUserSaveRequested(
    UserSaveRequested event,
    Emitter<UserState> emit,
  ) async {
    if (state.draft == null) return;

    final validationError = _validateUser(state.draft!);
    if (validationError != null) {
      emit(state.copyWith(error: validationError, clearSuccess: true));
      return;
    }

    emit(state.copyWith(isSaving: true, clearError: true, clearSuccess: true));

    final result = await repository.updateUser(state.draft!);

    result.fold(
      (error) {
        emit(state.copyWith(isSaving: false, error: error));
      },
      (updatedUser) {
        emit(
          state.copyWith(
            user: updatedUser,
            draft: updatedUser,
            isSaving: false,
            hasUnsavedChanges: false,
            saveSuccess: true,
            clearError: true,
          ),
        );
      },
    );
  }

  UserModel _copyUserWith(
    UserModel user, {
    String? name,
    String? email,
    String? language,
    String? dateFormat,
    String? timezone,
    AdressUserModel? address,
  }) {
    return UserModel(
      id: user.id,
      name: name ?? user.name,
      email: email ?? user.email,
      language: language ?? user.language,
      dateFormat: dateFormat ?? user.dateFormat,
      timezone: timezone ?? user.timezone,
      address: address ?? user.address,
      updatedAt: user.updatedAt,
    );
  }

  AdressUserModel _copyAddressWith(
    AdressUserModel address, {
    String? zipCode,
    String? country,
    String? street,
    String? number,
    String? complement,
    String? neighborhood,
    String? city,
    String? state,
  }) {
    return AdressUserModel(
      zipCode: zipCode ?? address.zipCode,
      country: country ?? address.country,
      street: street ?? address.street,
      number: number ?? address.number,
      complement: complement ?? address.complement,
      neighborhood: neighborhood ?? address.neighborhood,
      city: city ?? address.city,
      state: state ?? address.state,
    );
  }

  bool _hasChanges(UserModel? original, UserModel? draft) {
    if (original == null || draft == null) return false;

    final originalJson = original.toJson().toString();
    final draftJson = draft.toJson().toString();

    return originalJson != draftJson;
  }

  AppError? _validateUser(UserModel user) {
    if (user.name.trim().isEmpty) {
      return ValidationError('Nome é obrigatório');
    }

    if (user.email.trim().isEmpty) {
      return ValidationError('E-mail é obrigatório');
    }

    if (!Validators.isValidEmail(user.email)) {
      return ValidationError('E-mail inválido');
    }

    return null;
  }
}
