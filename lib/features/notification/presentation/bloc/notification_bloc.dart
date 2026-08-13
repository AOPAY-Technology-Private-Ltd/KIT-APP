import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecaes/get_notifications_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;

  NotificationBloc({required this.getNotificationsUseCase}) : super(NotificationInitial()) {
    on<FetchNotificationsEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notifications = await getNotificationsUseCase();
        emit(NotificationLoaded(notifications));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
  }
}