class GroupMember {
  final String name;
  final String kakaoId;
  final String thumbnailImage;

  GroupMember({
    required this.name,
    required this.kakaoId,
    required this.thumbnailImage,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      name: json['name'],
      kakaoId: json['kakaoId'],
      thumbnailImage: json['thumbnailImage'],
    );
  }
}
