import '../entity/weather.dart';

abstract class WeatherDao {
  Future<Weather> getCurrentWeather(int campus);
}
