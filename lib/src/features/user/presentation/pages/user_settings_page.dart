import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/core/utils/snackbar_helper.dart';
import 'package:nortus/src/core/widgets/nortus_nav_item.dart';
import 'package:nortus/src/core/widgets/nortus_scaffold.dart';
import 'package:nortus/src/features/user/presentation/bloc/user_bloc.dart';
import 'package:nortus/src/features/user/presentation/bloc/user_event.dart';
import 'package:nortus/src/features/user/presentation/bloc/user_state.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  @override
  void initState() {
    super.initState();
    final state = context.read<UserBloc>().state;
    if (state.user == null) {
      context.read<UserBloc>().add(const UserStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return NortusScaffold(
      activeItem: NortusNavItem.profile,
      showAppBar: false,
      showFooter: true,
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state.error != null) {
            SnackbarHelper.showError(context, state.error!.message);
          }

          if (state.saveSuccess) {
            SnackbarHelper.showSuccess(
              context,
              'Dados atualizados com sucesso!',
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.draft == null) {
            return const SizedBox.shrink();
          }

          return _buildContent(context, state);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserState state) {
    final draft = state.draft!;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: InkWell(
                      onTap: () => context.pop(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/arrow-left.svg',
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              AppColors.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Voltar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Configurações de usuário',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Ajustes de Idioma, Fuso Horário e Data',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildDropdown(
                    context,
                    label: 'Idioma',
                    value: draft.language,
                    items: const {
                      'pt-BR': 'Português - BR',
                      'en-US': 'English - US',
                      'es-ES': 'Español - ES',
                    },
                    defaultValue: 'pt-BR',
                    onChanged: (value) {
                      if (value != null) {
                        context.read<UserBloc>().add(
                          UserLanguageChanged(value),
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          context,
                          label: 'Formatação de data',
                          value: draft.dateFormat,
                          items: const {
                            'DD/MM/YYYY': 'DD/MM/AA',
                            'MM/DD/YYYY': 'MM/DD/AA',
                            'YYYY-MM-DD': 'AA/MM/DD',
                          },
                          defaultValue: 'DD/MM/YYYY',
                          onChanged: (value) {
                            if (value != null) {
                              context.read<UserBloc>().add(
                                UserDateFormatChanged(value),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdown(
                          context,
                          label: 'Fuso horário',
                          value: draft.timezone,
                          items: const {
                            'America/Sao_Paulo': 'Brasília - DF (GMT-3)',
                            'America/New_York': 'New York (GMT-5)',
                            'Europe/London': 'London (GMT+0)',
                            'Asia/Tokyo': 'Tokyo (GMT+9)',
                          },
                          defaultValue: 'America/Sao_Paulo',
                          onChanged: (value) {
                            if (value != null) {
                              context.read<UserBloc>().add(
                                UserTimezoneChanged(value),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Informações básicas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Dados pessoais',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildTextField(
                    context,
                    value: draft.name,
                    onChanged: (value) {
                      context.read<UserBloc>().add(UserNameChanged(value));
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildTextField(
                    context,
                    value: draft.email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      context.read<UserBloc>().add(UserEmailChanged(value));
                    },
                  ),
                ),

                const SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Endereço',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          context,
                          value: draft.address.zipCode,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            context.read<UserBloc>().add(
                              UserZipCodeChanged(value),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          context,
                          value: draft.address.country,
                          onChanged: (value) {
                            context.read<UserBloc>().add(
                              UserCountryChanged(value),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildTextField(
                    context,
                    value: draft.address.street,
                    onChanged: (value) {
                      context.read<UserBloc>().add(UserStreetChanged(value));
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildTextField(
                    context,
                    value: draft.address.complement,
                    onChanged: (value) {
                      context.read<UserBloc>().add(
                        UserComplementChanged(value),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildTextField(
                          context,
                          value: draft.address.number,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            context.read<UserBloc>().add(
                              UserNumberChanged(value),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 6,
                        child: _buildTextField(
                          context,
                          value: draft.address.neighborhood,
                          onChanged: (value) {
                            context.read<UserBloc>().add(
                              UserNeighborhoodChanged(value),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: _buildTextField(
                          context,
                          value: draft.address.city,
                          onChanged: (value) {
                            context.read<UserBloc>().add(
                              UserCityChanged(value),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: _buildTextField(
                          context,
                          value: draft.address.state,
                          onChanged: (value) {
                            context.read<UserBloc>().add(
                              UserStateChanged(value),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildBottomActions(context, state),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String value,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: TextStyle(color: AppColors.inputTextColor, fontSize: 12),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required String label,
    required String value,
    required Map<String, String> items,
    required String defaultValue,
    required ValueChanged<String?> onChanged,
  }) {
    final selectedValue = items.containsKey(value) ? value : defaultValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: onChanged,
          isExpanded: true,
          icon: Transform.rotate(
            angle: 1.5708,
            child: SvgPicture.asset(
              'assets/icons/arrow.svg',
              width: 12,
              height: 12,
              colorFilter: ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          items:
              items.entries
                  .map(
                    (entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.primaryBackground),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.primaryBackground),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: AppColors.primaryBackground,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context, UserState state) {
    final canSave = state.hasUnsavedChanges && !state.isSaving;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed:
                state.isSaving
                    ? null
                    : () {
                      context.read<UserBloc>().add(const UserEditCanceled());
                    },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: BorderSide(color: AppColors.searchInputBorder),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: const Text('Cancelar'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed:
                canSave
                    ? () {
                      context.read<UserBloc>().add(const UserSaveRequested());
                    }
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.searchInputBorder,
              disabledForegroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child:
                state.isSaving
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                    : const Text('Salvar'),
          ),
        ),
      ],
    );
  }
}
