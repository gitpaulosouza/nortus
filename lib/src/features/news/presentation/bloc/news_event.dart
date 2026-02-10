abstract class NewsEvent {
  const NewsEvent();
}

class NewsStarted extends NewsEvent {
  const NewsStarted();
}

class NewsLoadMoreRequested extends NewsEvent {
  const NewsLoadMoreRequested();
}

class NewsRefreshed extends NewsEvent {
  const NewsRefreshed();
}

class NewsSearchQueryChanged extends NewsEvent {
  final String query;

  const NewsSearchQueryChanged(this.query);
}
