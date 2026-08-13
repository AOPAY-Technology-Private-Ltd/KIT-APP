import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_qr_data_usecase.dart';
import 'qr_event.dart';
import 'qr_state.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  final GetQrDataUseCase getQrDataUseCase;

  QrBloc({required this.getQrDataUseCase}) : super(QrInitialState()) {
    on<LoadQrDataEvent>(_onLoadQrData);
    on<NextQrTappedEvent>(_onNextQrTapped);
  }

  Future<void> _onLoadQrData(LoadQrDataEvent event, Emitter<QrState> emit) async {
    emit(QrLoadingState());
    try {
      final user = await getQrDataUseCase();
      emit(QrLoadedState(user: user));
    } catch (e) {
      emit(QrErrorState(message: e.toString()));
    }
  }

  void _onNextQrTapped(NextQrTappedEvent event, Emitter<QrState> emit) {
  }
}