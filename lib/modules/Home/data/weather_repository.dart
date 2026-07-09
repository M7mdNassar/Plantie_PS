import 'package:dio/dio.dart';
import '../../../models/weather_model.dart';

class WeatherRepository {
  final Dio _dio = Dio();

  Future<WeatherData> getWeatherData(double lat, double lon) async {
    try {
      final response = await _dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'current': [
            'temperature_2m',
            'relative_humidity_2m',
            'precipitation',
            'weather_code',
            'wind_speed_10m',
            'is_day'
          ],
          'hourly': [
            'temperature_2m',
            'relative_humidity_2m',
            'precipitation',
            'wind_speed_10m',
            'soil_temperature_0cm'
          ],
          'daily': [
            'weather_code',
            'temperature_2m_max',
            'temperature_2m_min',
            'precipitation_sum',
            'et0_fao_evapotranspiration'
          ],
          'timezone': 'auto',
        },
      );

      if (response.statusCode == 200) {
        return WeatherData.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}