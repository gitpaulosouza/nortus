part of 'splash_bloc.dart';

class SplashState {
  final String? nextRoute;

  const SplashState({
    this.nextRoute,
  });

  const SplashState.initial() : nextRoute = null;

  SplashState copyWith({
    String? nextRoute,
  }) {
    return SplashState(
      nextRoute: nextRoute ?? this.nextRoute,
    );
  }
}
