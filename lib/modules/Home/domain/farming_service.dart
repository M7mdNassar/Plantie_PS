import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../models/weather_model.dart';
import 'farming_insight.dart';

class FarmingService {
  static List<FarmingInsight> getInsights(WeatherData weather, BuildContext context) {
    List<FarmingInsight> insights = [];
    final s = S.of(context);

    // Rain / Irrigation Logic
    final precipitation = weather.current.precipitation;
    if (precipitation > 2.0) {
      insights.add(FarmingInsight(
        title: s.irrigation_alert,
        message: s.irrigation_message(precipitation),
        icon: Icons.water_drop,
        level: InsightLevel.warning,
      ));
    }

    // Wind / Spraying Logic
    final windSpeed = weather.current.windSpeed;
    if (windSpeed > 15.0) {
      insights.add(FarmingInsight(
        title: s.wind_warning,
        message: s.wind_message(windSpeed),
        icon: Icons.air,
        level: InsightLevel.critical,
      ));
    } else if (windSpeed < 10.0) {
       insights.add(FarmingInsight(
        title: s.ideal_spraying,
        message: s.ideal_spraying_message,
        icon: Icons.check_circle_outline,
        level: InsightLevel.good,
      ));
    }

    // Temperature / Frost Logic
    final temp = weather.current.temperature;
    if (temp < 4.0) {
      insights.add(FarmingInsight(
        title: s.frost_risk,
        message: s.frost_message(temp),
        icon: Icons.ac_unit,
        level: InsightLevel.critical,
      ));
    }

    // Evapotranspiration Logic
    final et0 = weather.daily.evapotranspiration.first;
    if (et0 > 5.0) {
      insights.add(FarmingInsight(
        title: s.high_evaporation,
        message: s.high_evaporation_message(et0),
        icon: Icons.wb_sunny,
        level: InsightLevel.warning,
      ));
    }

    // Soil Temp
    final soilTemp = weather.hourly.soilTemperature.first;
    if (soilTemp > 10.0 && soilTemp < 25.0) {
      insights.add(FarmingInsight(
        title: s.soil_condition,
        message: s.soil_condition_message(soilTemp),
        icon: Icons.grass,
        level: InsightLevel.good,
      ));
    }

    return insights;
  }
}
