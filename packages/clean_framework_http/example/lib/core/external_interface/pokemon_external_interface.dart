import 'package:clean_framework_http/clean_framework_http.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonExternalInterface extends HttpExternalInterface {
  PokemonExternalInterface()
      : super(delegate: _PokemonHttpExternalInterfaceDelegate());
}

class _PokemonHttpExternalInterfaceDelegate
    extends HttpExternalInterfaceDelegate {
  @override
  Future<HttpOptions> buildOptions() async {
    final prefs = await SharedPreferences.getInstance();

    return HttpOptions(
      baseUrl: prefs.getString('BASE_URL')!,
      responseType: HttpResponseType.json,
    );
  }

  @override
  Dio buildDio(BaseOptions options) {
    return Dio(options)
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          compact: false,
        ),
      );
  }
}
