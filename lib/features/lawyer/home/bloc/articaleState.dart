import 'package:law_counsel_app/features/lawyer/model/articleModel.dart';

abstract class ArticleState {}

class ArticlesInitial extends ArticleState {}
class ArticlesLoading extends ArticleState {}
class ArticlesLoaded extends ArticleState {
  final List<ArticleModel> articles;
  ArticlesLoaded(this.articles);
}
class ArticlesError extends ArticleState {
  final String message;
  ArticlesError(this.message);
}