abstract class CreateArticleState {}

class CreateArticleInitial extends CreateArticleState {}

class CreateArticleLoading extends CreateArticleState {}

class CreateArticleSuccess extends CreateArticleState {}

class CreateArticleFailure extends CreateArticleState {
  final String message;

  CreateArticleFailure(this.message);
}
