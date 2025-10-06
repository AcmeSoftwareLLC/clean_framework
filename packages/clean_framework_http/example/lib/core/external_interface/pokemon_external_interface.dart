import 'package:clean_framework_http/clean_framework_http.dart';
import 'package:dio/dio.dart';
import 'package:http_cache_sembast_store/http_cache_sembast_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonExternalInterface extends HttpExternalInterface {
  PokemonExternalInterface()
      : super(delegate: _PokemonHttpExternalInterfaceDelegate());
}

class _PokemonHttpExternalInterfaceDelegate
    extends HttpExternalInterfaceDelegate {
  _PokemonHttpExternalInterfaceDelegate();

  @override
  Future<HttpOptions> buildOptions() async {
    final prefs = await SharedPreferences.getInstance();

    return HttpOptions(
      baseUrl: prefs.getString('BASE_URL')!,
    );
  }

  @override
  Future<Dio> buildDio(BaseOptions options) async {
    final dio = await super.buildDio(options);
    return dio
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          compact: false,
        ),
      );
  }

  @override
  Future<HttpCacheOptions?> buildCacheOptions() async {
    final supportDirectory = await getApplicationSupportDirectory();

    return HttpCacheOptions(
      store: SembastCacheStore(storePath: supportDirectory.path),
      policy: HttpCachePolicy.forceCache.value,
      maxStale: const Duration(days: 7),
    );
  }
}
