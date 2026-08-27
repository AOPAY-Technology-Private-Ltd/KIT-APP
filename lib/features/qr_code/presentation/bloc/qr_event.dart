abstract class QrEvent {}

class LoadQrDataEvent extends QrEvent {}

class NextQrTappedEvent extends QrEvent {}

class ValidateApiKeyEvent extends QrEvent {
  final String apiKey;
  ValidateApiKeyEvent({required this.apiKey});
}