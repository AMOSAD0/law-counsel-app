import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_counsel_app/core/helper/image_upload_helper.dart';
import 'package:law_counsel_app/features/lawyer/model/articleModel.dart';
import 'package:law_counsel_app/features/lawyer/myArticals/bloc/createArticaleEvent.dart';
import 'package:law_counsel_app/features/lawyer/myArticals/bloc/createArticaleState.dart';

class CreateArticleBloc extends Bloc<CreateArticleEvent, CreateArticleState> {
  CreateArticleBloc() : super(CreateArticleInitial()) {
    on<PublishArticle>(_onPublishArticle);
  }

  Future<void> _onPublishArticle(
    PublishArticle event,
    Emitter<CreateArticleState> emit,
  ) async {
    emit(CreateArticleLoading());

    try {
      String? imageUrl;

        imageUrl = await ImageUploadHelper.uploadImageToKit(
        event.image,
      );

      final article = ArticleModel(
        content: event.content,
        imageUrl: imageUrl,
        userId: event.userId,
        userName: event.userName,
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('articles')
          .add(article.toMap());

      emit(CreateArticleSuccess());
    } catch (e) {
      emit(CreateArticleFailure(e.toString()));
    }
  }
}
