import 'package:nortus/src/features/news/data/models/news_model.dart';

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

class NewsFavoriteToggled extends NewsEvent {
  final NewsModel news;

  const NewsFavoriteToggled(this.news);
}

class NewsFavoriteFeedbackConsumed extends NewsEvent {
  const NewsFavoriteFeedbackConsumed();
}
