 import 'dart:io';


abstract class CreateArticleEvent {}

class PublishArticle extends CreateArticleEvent {
  final String content;
  final File? image;
  final String userId;
  final String userName;

  PublishArticle({
    required this.content,
    this.image,
    required this.userId,
    required this.userName,
  });
}

