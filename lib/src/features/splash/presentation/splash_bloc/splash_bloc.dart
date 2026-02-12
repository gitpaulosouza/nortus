import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/src/core/storage/local_storage.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final LocalStorage localStorage;

  SplashBloc(this.localStorage) : super(const SplashState.initial()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 3));
    final isLoggedIn = await localStorage.isLoggedIn();
    final nextRoute = isLoggedIn ? '/news' : '/login';
    emit(state.copyWith(nextRoute: nextRoute));
  }
}
