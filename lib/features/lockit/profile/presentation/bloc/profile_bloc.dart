import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/session_manager.dart';
import '../../domain/usecaes/get_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileBloc({required this.getProfileUseCase}) : super(ProfileInitial()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onFetchProfile(
      FetchProfileEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final profile = await getProfileUseCase.execute();
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onLogout(
      LogoutEvent event,
      Emitter<ProfileState> emit,
      ) async {
    try {
      emit(ProfileLoading());

      await SessionManager.clearSession();

      emit(ProfileLoggedOutState());
    } catch (e) {
      emit(ProfileError(message: "Failed to logout: ${e.toString()}"));
    }
  }
}