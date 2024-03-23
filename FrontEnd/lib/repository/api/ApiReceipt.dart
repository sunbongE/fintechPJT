import 'package:dio/dio.dart';
import 'package:front/repository/commons.dart';

final api = ApiClient();

Future<Response> postReceiptImage(FormData formData) async {
  var dio = Dio();
  try {
    final res = await dio.post(
      'https://0xk6maip7m.apigw.ntruss.com/custom/v1/29150/799498f1feeb274ee00714974948725693d0eb995f5478622e975cd57c51c4f7/document/receipt',
      data: formData,
      options: Options(
        headers: {
          // 'X-OCR-SECRET': 'eGduV3FSVHNaZklGeGxVT1J4R1drd2diT1pMeGxiT0o=',
        },
      ),
    );
    return res;
  } catch (err) {
    print("Error posting image: $err");
    throw Exception('Failed to post user info');
  }
}
