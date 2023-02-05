import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:mimir/design/user_widgets/dialog.dart';
import 'package:mimir/global/desktop_init.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/module/shared/entity/weather.dart';
import 'package:mimir/storage/init.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

class HomeBackground extends StatefulWidget {
  final int? initialWeatherCode;

  const HomeBackground({this.initialWeatherCode, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeBackgroundState();
}

class _HomeBackgroundState extends State<HomeBackground> {
  late int _weatherCode;

  @override
  void initState() {
    super.initState();
    final lastWeather = Kv.home.lastWeather ?? Weather.defaultWeather;
    _weatherCode = widget.initialWeatherCode ?? int.tryParse(lastWeather.icon) ?? Weather.defaultWeatherCode;
    Global.eventBus.on(EventNameConstants.onBackgroundChange, _onBackgroundUpdate);
    Global.eventBus.on(EventNameConstants.onWeatherUpdate, _onWeatherUpdate);
    if (UniversalPlatform.isDesktop) {
      DesktopInit.eventBus.on<Size>(WindowEvent.onWindowResize, _onWindowResize);
    }
  }

  @override
  void deactivate() {
    Global.eventBus.off(EventNameConstants.onBackgroundChange, _onBackgroundUpdate);
    Global.eventBus.off(EventNameConstants.onWeatherUpdate, _onWeatherUpdate);
    if (UniversalPlatform.isDesktop) {
      DesktopInit.eventBus.off(WindowEvent.onWindowResize, _onWindowResize);
    }
    super.deactivate();
  }

  void _onWindowResize(Size? size) {
    // Windows端这里必须等一会儿才能使setState生效
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (!DesktopInit.eventBus.contain(WindowEvent.onWindowResize, _onWindowResize)) {
          return;
        }
        setState(() {});
      },
    );
  }

  WeatherType _getWeatherTypeByCode(int code) {
    return _weatherCodeToType[code] ?? WeatherType.sunny;
  }

  void _onBackgroundUpdate(_) {
    if (Kv.home.background == null) {
      context.showSnackBar( i18n.settingsWallpaperEmptyWarn.text());
      return;
    }
    setState(() {});
  }

  void _onWeatherUpdate(dynamic newWeather) {
    Weather w = newWeather as Weather;

    // 天气背景
    if (Kv.home.backgroundMode == 1) {
      setState(() => _weatherCode = int.parse(w.icon));
    } else {
      _weatherCode = int.parse(w.icon);
    }
  }

  Widget _buildWeatherBg() {
    return WeatherBg(
      weatherType: _getWeatherTypeByCode(_weatherCode),
      width: 1.sw,
      height: 1.sh,
    );
  }

  Widget _buildImageBg(File file) {
    return Image.file(file, fit: BoxFit.fill);
  }

  @override
  Widget build(BuildContext context) {
    if (Kv.home.backgroundMode == 2) {
      final backgroundSelected = Kv.home.background;
      if (backgroundSelected != null) {
        return _buildImageBg(File(backgroundSelected));
      } else {
        Future.delayed(
          Duration.zero,
          () => context.showSnackBar(i18n.settingsWallpaperEmptyWarn.text()),
        );
      }
    }
    return _buildWeatherBg();
  }
}

const _weatherCodeToType = {
  100: WeatherType.sunny, // 晴
  101: WeatherType.cloudy, // 多云
  102: WeatherType.sunny, // 少云
  103: WeatherType.sunny, // 晴间多云
  104: WeatherType.overcast, // 阴
  150: WeatherType.sunnyNight, // 晴
  151: WeatherType.cloudy, // 多云
  152: WeatherType.sunnyNight, // 少云
  153: WeatherType.sunnyNight, // 晴间多云
  154: WeatherType.overcast, // 阴
  300: WeatherType.lightRainy, // 阵雨
  301: WeatherType.middleRainy, // 强阵雨
  302: WeatherType.thunder, // 雷阵雨
  303: WeatherType.thunder, // 强雷阵雨
  304: WeatherType.thunder, // 雷阵雨伴有冰雹
  305: WeatherType.lightRainy, // 小雨
  306: WeatherType.middleRainy, // 中雨
  307: WeatherType.heavyRainy, // 大雨
  308: WeatherType.heavyRainy, // 极端降雨
  309: WeatherType.lightRainy, // 毛毛雨/细雨
  310: WeatherType.heavyRainy, // 暴雨
  311: WeatherType.heavyRainy, // 大暴雨
  312: WeatherType.heavyRainy, // 特大暴雨
  313: WeatherType.middleRainy, // 冻雨
  314: WeatherType.middleRainy, // 小到中雨
  315: WeatherType.middleRainy, // 中到大雨
  316: WeatherType.heavyRainy, // 大到暴雨
  317: WeatherType.heavyRainy, // 暴雨到大暴雨
  318: WeatherType.heavyRainy, // 大暴雨到特大暴雨
  350: WeatherType.lightRainy, // 阵雨
  351: WeatherType.heavyRainy, // 强阵雨
  399: WeatherType.lightRainy, // 雨
  400: WeatherType.lightSnow, // 小雪
  401: WeatherType.middleSnow, // 中雪
  402: WeatherType.heavySnow, // 大雪
  403: WeatherType.heavySnow, // 暴雪
  404: WeatherType.middleSnow, // 雨夹雪
  405: WeatherType.middleSnow, // 雨雪天气
  406: WeatherType.middleSnow, // 阵雨夹雪
  407: WeatherType.middleSnow, // 阵雪
  408: WeatherType.middleSnow, // 小到中雪
  409: WeatherType.middleSnow, // 中到大雪
  410: WeatherType.heavySnow, // 大到暴雪
  456: WeatherType.heavySnow, // 阵雨夹雪
  457: WeatherType.heavySnow, // 阵雪
  499: WeatherType.lightSnow, // 雪
  500: WeatherType.foggy, // 薄雾
  501: WeatherType.foggy, // 雾
  502: WeatherType.hazy, // 霾
  503: WeatherType.dusty, // 扬沙
  504: WeatherType.dusty, // 浮尘
  507: WeatherType.dusty, // 沙尘暴
  508: WeatherType.dusty, // 强沙尘暴
  509: WeatherType.foggy, // 浓雾
  510: WeatherType.foggy, // 强浓雾
  511: WeatherType.hazy, // 中度霾
  512: WeatherType.hazy, // 重度霾
  513: WeatherType.hazy, // 严重霾
  514: WeatherType.foggy, // 大雾
  515: WeatherType.foggy, // 特强浓雾
  800: WeatherType.sunnyNight, // 新月
  801: WeatherType.sunnyNight, // 蛾眉月
  802: WeatherType.sunnyNight, // 上弦月
  803: WeatherType.sunnyNight, // 盈凸月
  804: WeatherType.sunnyNight, // 满月
  805: WeatherType.sunnyNight, // 亏凸月
  806: WeatherType.sunnyNight, // 下弦月
  807: WeatherType.sunnyNight, // 残月
  900: WeatherType.sunny, // 热
  901: WeatherType.overcast, // 冷
  999: WeatherType.sunny, // 未知
};
