import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import '../../generated/l10n.dart';
import '../../layout/cubit/cubit.dart';
import '../../models/weather_model.dart';

class WeatherDetailsScreen extends StatefulWidget {
  final WeatherData weatherData;

  const WeatherDetailsScreen({super.key, required this.weatherData});

  @override
  _WeatherDetailsScreenState createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).weather_details),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildWeatherCard(context),
            SizedBox(height: 20),
            _buildDetailGrid(context),
            SizedBox(height: 20),
            _buildSunriseSunsetCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(BuildContext context) {
    return Card(
      color: AppCubit.get(context).isDark
          ? HexColor("1C1C1E")
          : HexColor("FFFFFF"),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              S.of(context).current_weather,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16),
            Text(
              '${widget.weatherData.main.temp.round()}°C',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      children: [
        _buildDetailItem(S.of(context).feels_like,
            '${widget.weatherData.main.feelsLike.round()}°C'),
        _buildDetailItem(
            S.of(context).humidity, '${widget.weatherData.main.humidity}%'),
        _buildDetailItem(
            S.of(context).wind_speed, '${widget.weatherData.wind.speed} m/s'),
        _buildDetailItem(
            S.of(context).pressure, '${widget.weatherData.main.pressure} hPa'),
      ],
    );
  }

  Widget _buildSunriseSunsetCard(BuildContext context) {
    return Card(
      color: AppCubit.get(context).isDark
          ? HexColor("1C1C1E")
          : HexColor("FFFFFF"),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSunTime(
                S.of(context).sunrise, widget.weatherData.sys.sunrise),
            _buildSunTime(S.of(context).sunset, widget.weatherData.sys.sunset),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Card(
      color: AppCubit.get(context).isDark
          ? HexColor("1C1C1E")
          : HexColor("FFFFFF"),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSunTime(String label, DateTime time) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Text(
          DateFormat('h:mm a').format(time),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
