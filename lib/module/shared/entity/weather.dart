import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/hive/type_id.dart';
import 'package:mimir/l10n/extension.dart';

part 'weather.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeId.weather)
class Weather {
  @HiveField(0)
  String weather;
  @HiveField(1)
  int temperature;
  @HiveField(2)
  String ts;
  @HiveField(3)
  String icon;

  Weather(this.weather, this.temperature, this.ts, this.icon);
  static const defaultWeatherCode = 100;
  static Weather get defaultWeather {
    return Weather(i18n.weather_sunny, 20, DateTime.now().toString(), defaultWeatherCode.toString());
  }

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);

  @override
  String toString() {
    return 'Weather{weather: $weather, temperature: $temperature, ts: $ts, icon: $icon}';
  }
}
