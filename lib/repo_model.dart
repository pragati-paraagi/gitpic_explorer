class Repo {
  final String id; // Use id instead of name
  final String description;
  final int commentCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RepoOwner? owner; // Nullable owner
  final Map<String, dynamic> files; // Add files field

  Repo({
    required this.id,
    required this.description,
    required this.commentCount,
    required this.createdAt,
    required this.updatedAt,
    this.owner,
    required this.files,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      id: json['id'] as String,
      description: json['description'] ?? '',
      commentCount: json['comments'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      owner: json['owner'] != null ? RepoOwner.fromJson(json['owner']) : null,
      files: json['files'] ?? {}, // Parse files here
    );
  }
}

class RepoOwner {
  final String avatarUrl;
  final String login;
  final String type;
  final String url;

  RepoOwner({
    required this.avatarUrl,
    required this.login,
    required this.type,
    required this.url,
  });

  factory RepoOwner.fromJson(Map<String, dynamic> json) {
    return RepoOwner(
      avatarUrl: json['avatar_url'] as String,
      login: json['login'] as String,
      type: json['type'] as String,
      url: json['html_url'] as String,
    );
  }
}
