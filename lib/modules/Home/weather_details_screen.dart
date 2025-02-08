import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:plantie/shared/styles/colors.dart';
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
        title: Text('Weather Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildWeatherCard(),
            SizedBox(height: 20),
            _buildDetailGrid(),
            SizedBox(height: 20),
            _buildSunriseSunsetCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
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
              'Current Weather',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16),
            Image.network(
              color: plantieColor,
              'https://openweathermap.org/img/wn/${widget.weatherData.weather.first.icon}@4x.png',
              width: 150,
              height: 150,
            ),
            Text(
              '${widget.weatherData.main.temp.round()}°C',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.weatherData.weather.first.description,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      children: [
        _buildDetailItem(
            'Feels Like', '${widget.weatherData.main.feelsLike.round()}°C'),
        _buildDetailItem('Humidity', '${widget.weatherData.main.humidity}%'),
        _buildDetailItem('Wind Speed', '${widget.weatherData.wind.speed} m/s'),
        _buildDetailItem('Pressure', '${widget.weatherData.main.pressure} hPa'),
      ],
    );
  }

  Widget _buildSunriseSunsetCard() {
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
            _buildSunTime('Sunrise', widget.weatherData.sys.sunrise),
            _buildSunTime('Sunset', widget.weatherData.sys.sunset),
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
