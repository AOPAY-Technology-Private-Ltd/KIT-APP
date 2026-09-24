import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecaes/get_support_data.dart';
import 'support_event.dart';
import 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final GetSupportData getSupportData;

  SupportBloc({required this.getSupportData}) : super(SupportInitial()) {
    on<LoadSupportDataEvent>(_onLoadSupportData);
  }

  Future<void> _onLoadSupportData(LoadSupportDataEvent event, Emitter<SupportState> emit) async {
    emit(SupportLoading());
    try {
      final data = await getSupportData();
      emit(SupportLoaded(
        faqs: data['faqs'],
        supportInfo: data['info'],
      ));
    } catch (e) {
      emit(SupportError(e.toString()));
    }
  }
}