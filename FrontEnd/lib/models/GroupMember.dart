class GroupMember {
  final String name;

  GroupMember({required this.name});

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      name: json['name'],
    );
  }
}