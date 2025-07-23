class ArticleModel {
  final String content;
  final String? imageUrl;
  final String? userImage;
  final String userId;
  final String userName;
  final DateTime createdAt;

  ArticleModel({
    required this.content,
    this.imageUrl,
    this.userImage,
    required this.userId,
    required this.userName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'imageUrl': imageUrl,
      'userId': userId,
      'userImage': userImage,
      'userName': userName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

   factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'],
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userImage: map['userImage'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
