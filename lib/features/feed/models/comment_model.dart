class CommentModel {
  final String userId;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.userId,
    required this.text,
    required this.createdAt,
  });
}
