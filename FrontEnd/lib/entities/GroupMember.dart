class GroupMember {
  final String name;
  final String email;
  final String profileimg;

  GroupMember({
    required this.name,
    required this.email,
    required this.profileimg,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      name: json['name'],
      email: json['email'],
      profileimg: json['profileimg'],
    );
  }
}
