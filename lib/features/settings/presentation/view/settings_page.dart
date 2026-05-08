import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme_extensions.dart';
import '../../../../core/widgets/app_error_dialog.dart';
import '../../../../core/widgets/app_form_components.dart';
import '../../../profile/presentation/view/edit_profile_page.dart';
import '../../../profile/domain/usecases/save_profile_usecase.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/profile_view_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsCubit = sl<SettingsCubit>();

    return BlocProvider(
      create: (_) => ProfileViewCubit(sl())..load(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.settings)),
        body: BlocListener<ProfileViewCubit, ProfileViewState>(
          listenWhen: (previous, current) =>
              previous.error != current.error && current.error != null,
          listener: (context, state) =>
              showAppErrorDialog(context, message: state.error!),
          child: BlocBuilder<ProfileViewCubit, ProfileViewState>(
            builder: (context, profileState) {
              final profile = profileState.profile;

              return BlocBuilder<SettingsCubit, SettingsState>(
                bloc: settingsCubit,
                builder: (context, settingsState) {
                  final customColors = Theme.of(
                    context,
                  ).extension<AppCustomColors>()!;
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        children: [
                          Text(
                            'Profile',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          FilledButton.icon(
                            onPressed: () async {
                              final changed = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProfilePage(
                                    initialProfile: profile,
                                    saveProfileUseCase:
                                        sl<SaveProfileUseCase>(),
                                  ),
                                ),
                              );
                              if (changed == true && context.mounted) {
                                context.read<ProfileViewCubit>().load();
                              }
                            },
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('Edit Profile'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primaryContainer,
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: customColors.avatarBorder,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: customColors.avatarShadow,
                                          blurRadius: 10,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 38,
                                      backgroundImage: profile.imagePath != null
                                          ? FileImage(File(profile.imagePath!))
                                          : null,
                                      child: profile.imagePath == null
                                          ? const Icon(Icons.person, size: 36)
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profile.name.isEmpty
                                              ? 'Your Name'
                                              : profile.name,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          profile.email.isEmpty
                                              ? 'your@email.com'
                                              : profile.email,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _ProfileInfoRow(
                                icon: Icons.cake_outlined,
                                label: 'Birth Date',
                                value: profile.birthDate == null
                                    ? '-'
                                    : DateFormat('dd MMM yyyy').format(
                                        DateTime.parse(profile.birthDate!),
                                      ),
                              ),
                              const SizedBox(height: 10),
                              _ProfileInfoRow(
                                icon: Icons.place_outlined,
                                label: 'Address',
                                value: profile.address ?? '-',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.theme,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      AppDropdownField<ThemeMode>(
                        initialValue: settingsState.themeMode,
                        items: [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text(l10n.system),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text(l10n.light),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text(l10n.dark),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) settingsCubit.setThemeMode(value);
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.language,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      AppDropdownField<Locale>(
                        initialValue: settingsState.locale,
                        items: const [
                          DropdownMenuItem(
                            value: Locale('en'),
                            child: Text('English'),
                          ),
                          DropdownMenuItem(
                            value: Locale('id'),
                            child: Text('Indonesia'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) settingsCubit.setLocale(value);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 2),
              Text(value, maxLines: 3, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}
