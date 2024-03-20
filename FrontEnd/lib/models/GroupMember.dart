class GroupMember {
  final String name;
  final String email;


  GroupMember({
    required this.name,
    required this.email,

  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      name: json['name'],
      email: json['email'],

    );
  }
}