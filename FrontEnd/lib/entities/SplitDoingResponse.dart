class SplitDoingResponse {
  final String name;
  final String kakaoId;
  final String thumbnailImage;
  bool isReady;

  SplitDoingResponse(
      {required this.name,
      required this.kakaoId,
      required this.thumbnailImage,
      this.isReady = false});

  factory SplitDoingResponse.fromJson(Map<String, dynamic> json) {
    return SplitDoingResponse(
      name: json['name'],
      kakaoId: json['kakaoId'],
      thumbnailImage: json['thumbnailImage'],
    );
  }

  @override
  String toString() {
    return 'SplitDoingResponse(name: $name, kakaoId: $kakaoId, thumbnailImage: $thumbnailImage, isReady: $isReady)';
  }
}
