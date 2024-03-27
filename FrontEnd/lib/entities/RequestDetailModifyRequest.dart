import 'package:front/entities/RequestMember.dart';

class RequestDetailModifyRequest {
  final String memo;
  final List<RequestMember> memberList;

  RequestDetailModifyRequest({
    required this.memo,
    required this.memberList,
  });
  Map<String, dynamic> toJson() {
    return {
      'memo': memo,
      'memberList': List<dynamic>.from(memberList.map((x) => x.toJson())),
    };
  }
  @override
  String toString() {
    return 'RequestDetailModifyRequest(memo: $memo, memberList: ${memberList.map((x) => x.toString()).join(', ')})';
  }
}