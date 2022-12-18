import 'package:dio/dio.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/storage/init.dart';

import '../dao/weather.dart';
import '../entity/weather.dart';

class WeatherService implements WeatherDao {
  static String _getWeatherUrl(int campus, int lang) => '${R.kiteDomain}/api/v2/weather/$campus?lang=$lang';

  @override
  Future<Weather> getCurrentWeather(int campus) async {
    var lang = Kv.pref.locale?.languageCode ?? Lang.zh;
    final url = _getWeatherUrl(campus, Lang.toCode(lang) ?? Lang.zhCode);
    final response = await Dio().get(url);
    final weather = Weather.fromJson(response.data['data']);

    return weather;
  }
}
