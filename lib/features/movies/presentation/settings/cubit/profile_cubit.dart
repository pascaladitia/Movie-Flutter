import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../profile/data/profile_local_data_source.dart';

class ProfileViewState extends Equatable {
  final bool isLoading;
  final ProfileData profile;
  final String? error;

  const ProfileViewState({required this.isLoading, required this.profile, required this.error});

  factory ProfileViewState.initial() => const ProfileViewState(isLoading: false, profile: ProfileData.empty, error: null);

  ProfileViewState copyWith({bool? isLoading, ProfileData? profile, String? error}) {
    return ProfileViewState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, profile, error];
}

class ProfileViewCubit extends Cubit<ProfileViewState> {
  final ProfileLocalDataSource localDataSource;

  ProfileViewCubit(this.localDataSource) : super(ProfileViewState.initial());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final profile = await localDataSource.getProfile();
      emit(state.copyWith(isLoading: false, profile: profile, error: null));
    } on Failure catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    } catch (_) {
      emit(state.copyWith(isLoading: false, error: 'DB: Failed to load profile'));
    }
  }
}