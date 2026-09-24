abstract class UpdateEmiState {}

class UpdateEmiInitial extends UpdateEmiState {}
class UpdateEmiLoading extends UpdateEmiState {}
class UpdateEmiSuccess extends UpdateEmiState {
  final String message;
  UpdateEmiSuccess({required this.message});
}
class UpdateEmiError extends UpdateEmiState {
  final String message;
  UpdateEmiError({required this.message});
}