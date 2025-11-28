class User {
  final int? id;
  final String displayName;
  final String email;
  final String username;
  final Map<String, String>? avatarUrls;

  User({
    this.id,
    required this.displayName,
    required this.email,
    required this.username,
    this.avatarUrls,
  });

  // Create User from JSON (API response)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      displayName: json['display_name'] ?? json['name'] ?? 'Guest',
      email: json['user_email'] ?? json['email'] ?? 'N/A',
      username: json['user_login'] ?? json['username'] ?? '',
      avatarUrls: json['avatar_urls'] != null 
          ? Map<String, String>.from(json['avatar_urls']) 
          : null,
    );
  }

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'user_email': email,
      'user_login': username,
      'avatar_urls': avatarUrls,
    };
  }

  // Get avatar URL with fallback sizes
  String getAvatarUrl() {
    if (avatarUrls == null) return '';
    return avatarUrls!['96'] ?? 
           avatarUrls!['48'] ?? 
           avatarUrls!['24'] ?? 
           '';
  }

  // Copy with method for updates
  User copyWith({
    int? id,
    String? displayName,
    String? email,
    String? username,
    Map<String, String>? avatarUrls,
  }) {
    return User(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrls: avatarUrls ?? this.avatarUrls,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, displayName: $displayName, email: $email, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id && other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode;
  }
}