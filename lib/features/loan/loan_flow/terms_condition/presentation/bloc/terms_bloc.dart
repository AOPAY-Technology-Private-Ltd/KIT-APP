import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/accept_terms_usecase.dart';
import 'terms_event.dart';
import 'terms_state.dart';

class TermsBloc extends Bloc<TermsEvent, TermsState> {
  final AcceptTermsUsecase acceptTermsUsecase;

  TermsBloc(this.acceptTermsUsecase) : super(TermsInitialState()) {
    on<SubmitTermsEvent>((event, emit) async {
      if (!event.isAccepted) {
        emit(TermsErrorState('Please accept the terms and conditions'));
        return;
      }

      emit(TermsLoadingState());
      try {
        final result = await acceptTermsUsecase(isAccepted: event.isAccepted);
        emit(TermsSuccessState(result.message));
      } catch (e) {
        emit(TermsErrorState(e.toString()));
      }
    });
  }
}