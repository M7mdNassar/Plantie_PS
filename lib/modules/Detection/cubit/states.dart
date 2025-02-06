abstract class DetectionStates {}

class DetectionInitialState extends DetectionStates {}

class DetectionLoadingState extends DetectionStates {}

class DetectionResultState extends DetectionStates {}

class HistoryUpdatedState extends DetectionStates {}

class DetectionErrorState extends DetectionStates {
  final String message;

  DetectionErrorState(this.message);
}

class HistoryErrorState extends DetectionStates {
  final String message;

  HistoryErrorState(this.message);
}

class HistoryLoadingState extends DetectionStates {}

class HistoryLoadedState extends DetectionStates {}
