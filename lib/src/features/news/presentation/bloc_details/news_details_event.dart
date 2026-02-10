abstract class NewsDetailsEvent {
  const NewsDetailsEvent();
}

class NewsDetailsStarted extends NewsDetailsEvent {
  final int newsId;
  const NewsDetailsStarted(this.newsId);
}

class NewsDetailsRefreshed extends NewsDetailsEvent {
  final int newsId;
  const NewsDetailsRefreshed(this.newsId);
}

class NewsDetailsLoadMoreRequested extends NewsDetailsEvent {
  const NewsDetailsLoadMoreRequested();
}
