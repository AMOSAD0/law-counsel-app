import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_counsel_app/features/lawyer/home/bloc/articaleEvent.dart';
import 'package:law_counsel_app/features/lawyer/home/bloc/articaleState.dart';
import 'package:law_counsel_app/features/lawyer/model/articleModel.dart';


class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  ArticleBloc() : super(ArticlesInitial()) {
    on<GetArticles>(_onGetArticles);
  }

  Future<void> _onGetArticles(
    GetArticles event,
    Emitter<ArticleState> emit,
  ) async {
    emit(ArticlesLoading());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('articles')
          .orderBy('createdAt', descending: true)
          .get();

      final articles = snapshot.docs.map((doc) {
        final data = doc.data();
        return ArticleModel(
          content: data['content'] ?? '',
          imageUrl: data['imageUrl'],
          userId: data['userId'] ?? '',
          userName: data['userName'] ?? '',
          createdAt: DateTime.parse(data['createdAt']),
        );
      }).toList();

      emit(ArticlesLoaded(articles));
    } catch (e) {
      emit(ArticlesError('فشل في تحميل المقالات'));
    }
  }
}