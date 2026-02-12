import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/di/app_injector.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/core/utils/snackbar_helper.dart';
import 'package:nortus/src/core/widgets/nortus_nav_item.dart';
import 'package:nortus/src/core/widgets/nortus_scaffold.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_event.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_state.dart';
import 'package:nortus/src/features/news/presentation/news_bloc/news_bloc.dart';
import 'package:nortus/src/features/user/presentation/user_bloc/user_bloc.dart';
import 'package:nortus/src/features/user/presentation/user_bloc/user_event.dart';
import 'package:nortus/src/features/user/presentation/user_bloc/user_state.dart';
import 'package:nortus/src/features/user/presentation/widgets/favorite_news_section.dart';
import 'package:nortus/src/features/user/presentation/widgets/profile_search_bar.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<UserBloc>()..add(const UserStarted()),
        ),
        BlocProvider(
          create: (_) => getIt<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<NewsBloc>(),
        ),
      ],
      child: const _UserPageContent(),
    );
  }
}

class _UserPageContent extends StatefulWidget {
  const _UserPageContent();

  @override
  State<_UserPageContent> createState() => _UserPageContentState();
}

class _UserPageContentState extends State<_UserPageContent> {
  String _searchQuery = '';

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state.error != null) {
              SnackbarHelper.showError(
                context,
                'Erro ao carregar perfil',
                subtitle: state.error!.message,
              );
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isLogoutSuccess) {
              context.go('/login');
            } else if (state.errorMessage != null && !state.isSubmitting) {
              SnackbarHelper.showError(
                context,
                'Erro ao sair da conta',
                subtitle: state.errorMessage!,
              );
            }
          },
        ),
      ],
      child: NortusScaffold(
        activeItem: NortusNavItem.profile,
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state.isLoading && state.user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null && state.user == null) {
              return _buildErrorState(context);
            }

            if (state.draft == null) {
              return const SizedBox.shrink();
            }

            return _buildContent(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar perfil',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tente novamente',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<UserBloc>().add(const UserRefreshed());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserState state) {
    final draft = state.draft!;
    final isSearchActive = _searchQuery.isNotEmpty;

    return Column(
      children: [
        ProfileSearchBar(
          onSearchChanged: _onSearchChanged,
          currentQuery: _searchQuery,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSearchActive) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          draft.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          draft.email,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (draft.address.city.isNotEmpty &&
                            draft.address.country.isNotEmpty)
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/location-icon.svg',
                                width: 16,
                                height: 16,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.textPrimary,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${draft.address.city}, ${draft.address.country}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              context.push(
                                '/user-settings',
                                extra: context.read<UserBloc>(),
                              );
                            },
                            icon: const Icon(Icons.settings_outlined),
                            label: const Text('Configurações de usuário'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              backgroundColor: AppColors.white,
                              side: const BorderSide(
                                color: AppColors.textPrimary,
                                width: 1,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(AuthLogoutRequested());
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.dangerRed,
                              backgroundColor: AppColors.white,
                              side: const BorderSide(
                                color: AppColors.dangerRed,
                                width: 1,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            child: const Text('Sair da conta'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                FavoriteNewsSection(searchQuery: _searchQuery),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
