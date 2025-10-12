class Comment {
  final String name;
  final String profilePicPath;
  final String text;
  final String date;
  final List<String> imagePaths;

  Comment({
    required this.name,
    required this.profilePicPath,
    required this.text,
    required this.date,
    this.imagePaths = const [],
  });
}
