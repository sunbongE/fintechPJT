class Member {
  final String kakaoId;
  final String name;
  final String email;
  final String profileImage;
  final String thumbnailImage;

  Member({
    required this.kakaoId,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.thumbnailImage,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      kakaoId: json['kakaoId'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      thumbnailImage: json['thumbnailImage'],
    );
  }
}
