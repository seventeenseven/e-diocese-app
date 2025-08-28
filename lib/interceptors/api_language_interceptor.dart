import 'package:http_interceptor/http_interceptor.dart';

class ApiLanguageInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      data.headers['Accept-Language'] = 'fr';
    } catch (exception) {
      print('Erreur lors de l\'ajout du header de langue: $exception');
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }

  @override
  Future<bool> shouldInterceptRequest() async => true;

  @override
  Future<bool> shouldInterceptResponse() async => true;
}
