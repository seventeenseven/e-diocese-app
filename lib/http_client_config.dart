// import 'package:akooba_flutter_app/interceptors/auth_guard_interceptor.dart';
import 'package:ediocese_app/interceptors/api_language_interceptor.dart';
import 'package:ediocese_app/interceptors/auth_guard_interceptor.dart';
import 'package:http_interceptor/http_interceptor.dart';

InterceptedClient initHttpClient() => InterceptedClient.build(
    interceptors: [ApiLanguageInterceptor(), AuthGuardInterceptor()]);
