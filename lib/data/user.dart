class User {
  final int reputation;
  final int userId;
  final String? location;
  final String profileImage;
  final String displayName;
  final int? age;

  User({
    required this.reputation,
    required this.userId,
    required this.location,
    required this.profileImage,
    required this.displayName,
    this.age,
  });

  User copyWith({
    int? reputation,
    int? userId,
    String? location,
    String? profileImage,
    String? displayName,
    int? age,
  }) {
    return User(
      reputation: reputation ?? this.reputation,
      userId: userId ?? this.userId,
      location: location ?? this.location,
      profileImage: profileImage ?? this.profileImage,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() => {
        'reputation': reputation,
        'user_id': userId,
        'location': location,
        'profile_image': profileImage,
        'display_name': displayName,
        'age': age,
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
        reputation: map['reputation']?.toInt(),
        userId: map['user_id']?.toInt(),
        location: map['location'],
        profileImage: map['profile_image'],
        displayName: map['display_name'],
        age: map['age'],
      );
}
