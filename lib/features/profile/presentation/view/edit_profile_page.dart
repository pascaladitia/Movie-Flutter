import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_error_dialog.dart';
import '../../../../core/widgets/app_form_components.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/save_profile_usecase.dart';
import '../cubit/edit_profile_cubit.dart';
import 'location_picker_page.dart';

class EditProfilePage extends StatefulWidget {
  final Profile initialProfile;
  final SaveProfileUseCase saveProfileUseCase;

  const EditProfilePage({
    super.key,
    required this.initialProfile,
    required this.saveProfileUseCase,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProfile.name);
    _emailController = TextEditingController(text: widget.initialProfile.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileCubit(
        saveProfileUseCase: widget.saveProfileUseCase,
        initialProfile: widget.initialProfile,
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listenWhen: (previous, current) =>
              previous.error != current.error && current.error != null,
          listener: (context, state) =>
              showAppErrorDialog(context, message: state.error!),
          builder: (context, state) {
            final cubit = context.read<EditProfileCubit>();
            final birthDate = state.profile.birthDate != null
                ? DateTime.tryParse(state.profile.birthDate!)
                : null;

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: state.profile.imagePath != null
                              ? FileImage(File(state.profile.imagePath!))
                              : null,
                          child: state.profile.imagePath == null
                              ? const Icon(Icons.person, size: 38)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () => cubit.pickImage(context),
                          icon: const Icon(Icons.add_a_photo_outlined),
                          label: const Text('Camera / Gallery'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppOutlinedTextField(
                    controller: _nameController,
                    label: 'Name',
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Name is required'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  AppFilledTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Email is required';
                      if (!text.contains('@')) return 'Invalid email format';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        lastDate: now,
                        initialDate:
                            birthDate ??
                            DateTime(now.year - 20, now.month, now.day),
                      );
                      if (picked != null) cubit.updateBirthDate(picked);
                    },
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text(
                      birthDate == null
                          ? 'Set Birth Date'
                          : DateFormat('dd MMM yyyy').format(birthDate),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(state.profile.address ?? 'Address not set'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: cubit.setLocationFromCurrent,
                        icon: const Icon(Icons.my_location),
                        label: const Text('Current Location'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final initial = LatLng(
                            state.profile.latitude ?? -6.2,
                            state.profile.longitude ?? 106.8,
                          );
                          final selected = await Navigator.push<LatLng>(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LocationPickerPage(initialLocation: initial),
                            ),
                          );
                          if (selected != null) {
                            await cubit.setLocationByCoordinates(
                              selected.latitude,
                              selected.longitude,
                            );
                          }
                        },
                        icon: const Icon(Icons.map_outlined),
                        label: const Text('Pick from Maps'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: state.isSaving
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;
                            cubit.updateName(_nameController.text.trim());
                            cubit.updateEmail(_emailController.text.trim());
                            await cubit.save();
                            if (!context.mounted) return;
                            if (context.read<EditProfileCubit>().state.error ==
                                null) {
                              Navigator.pop(context, true);
                            }
                          },
                    child: Text(state.isSaving ? 'Saving...' : 'Save Profile'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
