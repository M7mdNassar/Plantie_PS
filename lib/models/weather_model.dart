class WeatherData {
  final double latitude;
  final double longitude;
  final String timezone;
  final CurrentWeather current;
  final HourlyWeather hourly;
  final DailyWeather daily;

  WeatherData({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: json['timezone'] as String,
      current: CurrentWeather.fromJson(json['current']),
      hourly: HourlyWeather.fromJson(json['hourly']),
      daily: DailyWeather.fromJson(json['daily']),
    );
  }
}

class CurrentWeather {
  final String time;
  final double temperature;
  final int relativeHumidity;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;
  final int isDay;

  CurrentWeather({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
    required this.isDay,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: json['time'] as String,
      temperature: (json['temperature_2m'] as num).toDouble(),
      relativeHumidity: (json['relative_humidity_2m'] as num).toInt(),
      precipitation: (json['precipitation'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      isDay: (json['is_day'] as num).toInt(),
    );
  }
}

class HourlyWeather {
  final List<String> time;
  final List<double> temperature;
  final List<int> relativeHumidity;
  final List<double> precipitation;
  final List<double> windSpeed;
  final List<double> soilTemperature;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.precipitation,
    required this.windSpeed,
    required this.soilTemperature,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: List<String>.from(json['time']),
      temperature: List<double>.from(json['temperature_2m'].map((e) => (e as num).toDouble())),
      relativeHumidity: List<int>.from(json['relative_humidity_2m'].map((e) => (e as num).toInt())),
      precipitation: List<double>.from(json['precipitation'].map((e) => (e as num).toDouble())),
      windSpeed: List<double>.from(json['wind_speed_10m'].map((e) => (e as num).toDouble())),
      soilTemperature: List<double>.from(json['soil_temperature_0cm'].map((e) => (e as num).toDouble())),
    );
  }
}

class DailyWeather {
  final List<String> time;
  final List<int> weatherCode;
  final List<double> temperatureMax;
  final List<double> temperatureMin;
  final List<double> precipitationSum;
  final List<double> evapotranspiration;

  DailyWeather({
    required this.time,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.precipitationSum,
    required this.evapotranspiration,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      time: List<String>.from(json['time']),
      weatherCode: List<int>.from(json['weather_code'].map((e) => (e as num).toInt())),
      temperatureMax: List<double>.from(json['temperature_2m_max'].map((e) => (e as num).toDouble())),
      temperatureMin: List<double>.from(json['temperature_2m_min'].map((e) => (e as num).toDouble())),
      precipitationSum: List<double>.from(json['precipitation_sum'].map((e) => (e as num).toDouble())),
      evapotranspiration: List<double>.from(json['et0_fao_evapotranspiration'].map((e) => (e as num).toDouble())),
    );
  }
}
