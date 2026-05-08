import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/widgets/app_image_picker_component.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/save_profile_usecase.dart';

class EditProfileState extends Equatable {
  final bool isSaving;
  final Profile profile;
  final String? error;

  const EditProfileState({
    required this.isSaving,
    required this.profile,
    required this.error,
  });

  EditProfileState copyWith({bool? isSaving, Profile? profile, String? error}) {
    return EditProfileState(
      isSaving: isSaving ?? this.isSaving,
      profile: profile ?? this.profile,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isSaving, profile, error];
}

class EditProfileCubit extends Cubit<EditProfileState> {
  final SaveProfileUseCase saveProfileUseCase;

  EditProfileCubit({
    required this.saveProfileUseCase,
    required Profile initialProfile,
  }) : super(
         EditProfileState(
           isSaving: false,
           profile: initialProfile,
           error: null,
         ),
       );

  void updateName(String name) {
    emit(
      state.copyWith(profile: state.profile.copyWith(name: name), error: null),
    );
  }

  void updateEmail(String email) {
    emit(
      state.copyWith(
        profile: state.profile.copyWith(email: email),
        error: null,
      ),
    );
  }

  void updateBirthDate(DateTime? date) {
    emit(
      state.copyWith(
        profile: state.profile.copyWith(birthDate: date?.toIso8601String()),
        error: null,
      ),
    );
  }

  Future<void> pickImage(BuildContext context) async {
    final path = await AppImagePickerComponent.pickAndCompressImage(context);
    if (path == null) return;
    emit(
      state.copyWith(
        profile: state.profile.copyWith(imagePath: path),
        error: null,
      ),
    );
  }

  Future<void> setLocationFromCurrent() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        emit(state.copyWith(error: 'Location service disabled'));
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        emit(state.copyWith(error: 'Location permission denied'));
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      await setLocationByCoordinates(position.latitude, position.longitude);
    } catch (_) {
      emit(state.copyWith(error: 'Failed to get current location'));
    }
  }

  Future<void> setLocationByCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final places = await placemarkFromCoordinates(latitude, longitude);
      final first = places.isNotEmpty ? places.first : null;
      final address =
          [
                first?.street,
                first?.subLocality,
                first?.locality,
                first?.administrativeArea,
                first?.country,
              ]
              .where((e) => e != null && e.trim().isNotEmpty)
              .map((e) => e!.trim())
              .join(', ');

      emit(
        state.copyWith(
          profile: state.profile.copyWith(
            address: address.isEmpty ? '$latitude, $longitude' : address,
            latitude: latitude,
            longitude: longitude,
          ),
          error: null,
        ),
      );
    } catch (_) {
      emit(state.copyWith(error: 'Failed to resolve selected location'));
    }
  }

  Future<void> save() async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      await saveProfileUseCase(state.profile);
      emit(state.copyWith(isSaving: false, error: null));
    } on Failure catch (e) {
      emit(state.copyWith(isSaving: false, error: e.message));
    } catch (_) {
      emit(
        state.copyWith(isSaving: false, error: 'DB: Failed to save profile'),
      );
    }
  }
}
