abstract class HistoryEvent {}

class LoadHistoryEvent extends HistoryEvent {}

class SearchHistoryEvent extends HistoryEvent {
  final String query;
  SearchHistoryEvent(this.query);
}