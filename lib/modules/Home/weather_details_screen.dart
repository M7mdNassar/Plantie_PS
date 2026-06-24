import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:plantie/modules/Home/cubit/cubit.dart';
import 'package:plantie/modules/Home/domain/farming_insight.dart';
import '../../generated/l10n.dart';
import '../../models/weather_model.dart';
import '../../shared/styles/app_colors.dart';

class WeatherDetailsScreen extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherDetailsScreen({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final cubit = HomeCubit.get(context);
    cubit.generateInsights(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? HexColor("121212") : HexColor("F8F9FA"),
      appBar: AppBar(
        title: Text(S.of(context).weather_details),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainCurrentCard(context, isDark),
            const SizedBox(height: 24),
            _buildFarmingInsightsSection(context, cubit.insights, isDark),
            const SizedBox(height: 24),
            _buildWeatherCharts(context, isDark),
            const SizedBox(height: 24),
            _buildHourlyForecast(context, isDark),
            const SizedBox(height: 24),
            _buildMetricsGrid(context, isDark),
            const SizedBox(height: 24),
            _buildDailyForecast(context, isDark),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCurrentCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [HexColor("1E1E1E"), HexColor("2C2C2C")]
            : [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            DateFormat('EEEE, d MMMM').format(DateTime.now()),
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getWeatherIcon(weatherData.current.weatherCode, size: 80),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weatherData.current.temperature.round()}°',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getWeatherDescription(weatherData.current.weatherCode),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Divider(color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickMetric(Icons.water_drop, '${weatherData.current.relativeHumidity}%', S.of(context).humidity_level),
              _buildQuickMetric(Icons.air, '${weatherData.current.windSpeed} km/h', S.of(context).wind_speed),
              _buildQuickMetric(Icons.umbrella, '${weatherData.current.precipitation} mm', S.of(context).precipitation),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuickMetric(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }

  Widget _buildFarmingInsightsSection(BuildContext context, List<FarmingInsight> insights, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 12),
          child: Text(
            S.of(context).farming_insights,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        if (insights.isEmpty)
           _buildEmptyInsight(context, isDark)
        else
          ...insights.map((insight) => _buildInsightCard(insight, isDark)),
      ],
    );
  }

  Widget _buildEmptyInsight(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? HexColor("1C1C1E") : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).good_for_farming,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  S.of(context).no_insights,
                  style: TextStyle(color: isDark ? Colors.grey : Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(FarmingInsight insight, bool isDark) {
    final Color levelColor = insight.level == InsightLevel.critical 
        ? Colors.red 
        : (insight.level == InsightLevel.warning ? Colors.orange : Colors.green);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? HexColor("1C1C1E") : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: levelColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: levelColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: levelColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(insight.icon, color: levelColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: levelColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.message,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 12),
          child: Text(
            S.of(context).hourly_forecast,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 24,
            itemBuilder: (context, index) {
              final timeStr = weatherData.hourly.time[index];
              final time = DateTime.parse(timeStr);
              return Container(
                width: 70,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isDark ? HexColor("1C1C1E") : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(time),
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.grey : Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${weatherData.hourly.temperature[index].round()}°',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${weatherData.hourly.precipitation[index]}mm',
                      style: TextStyle(fontSize: 10, color: AppColors.primary),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherCharts(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 12),
          child: Text(
            S.of(context).weather_trends,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        Container(
          height: 250,
          padding: const EdgeInsets.fromLTRB(8, 24, 24, 8),
          decoration: BoxDecoration(
            color: isDark ? HexColor("1C1C1E") : Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: isDark ? Colors.white10 : Colors.black12,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 4,
                          getTitlesWidget: (value, meta) {
                            final hour = value.toInt();
                            return Text(
                              '$hour:00',
                              style: TextStyle(
                                color: isDark ? Colors.grey : Colors.grey[600],
                                fontSize: 10,
                              ),
                            );
                          },
                          reservedSize: 22,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 10,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toInt()}°',
                            style: TextStyle(color: isDark ? Colors.grey : Colors.grey[600], fontSize: 10),
                          ),
                          reservedSize: 28,
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(24, (i) => FlSpot(i.toDouble(), weatherData.hourly.temperature[i])),
                        isCurved: true,
                        color: Colors.orange,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.orange.withValues(alpha: 0.1),
                        ),
                      ),
                      LineChartBarData(
                        spots: List.generate(24, (i) => FlSpot(i.toDouble(), weatherData.hourly.precipitation[i] * 5)),
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildChartLegend(S.of(context).temperature_chart, Colors.orange),
                  const SizedBox(width: 24),
                  _buildChartLegend(S.of(context).precipitation_chart, Colors.blue),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildMetricsGrid(BuildContext context, bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildMetricCard(
          context,
          S.of(context).soil_temp,
          '${weatherData.hourly.soilTemperature.first.round()}°C',
          Icons.thermostat,
          Colors.brown,
          isDark,
        ),
        _buildMetricCard(
          context,
          S.of(context).evapotranspiration,
          '${weatherData.daily.evapotranspiration.first} mm',
          Icons.wb_sunny_outlined,
          Colors.orange,
          isDark,
        ),
        _buildMetricCard(
          context,
          S.of(context).humidity_level,
          '${weatherData.current.relativeHumidity}%',
          Icons.opacity,
          Colors.blue,
          isDark,
        ),
        _buildMetricCard(
          context,
          S.of(context).wind_speed,
          '${weatherData.current.windSpeed} km/h',
          Icons.air,
          Colors.blueGrey,
          isDark,
        ),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? HexColor("1C1C1E") : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.grey : Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyForecast(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 12),
          child: Text(
            S.of(context).daily_forecast,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? HexColor("1C1C1E") : Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 7,
            separatorBuilder: (context, index) => Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey[100]),
            itemBuilder: (context, index) {
              final date = DateTime.parse(weatherData.daily.time[index]);
              final isToday = index == 0;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        isToday ? S.of(context).today : DateFormat('EEEE').format(date),
                        style: TextStyle(fontWeight: isToday ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _getWeatherIcon(weatherData.daily.weatherCode[index], size: 30),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${weatherData.daily.temperatureMax[index].round()}°',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${weatherData.daily.temperatureMin[index].round()}°',
                            style: TextStyle(color: isDark ? Colors.grey : Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _getWeatherIcon(int code, {double size = 50}) {
    // WMO Weather interpretation codes (WW)
    if (code == 0) return Icon(Icons.wb_sunny, color: Colors.orange, size: size);
    if (code <= 3) return Icon(Icons.wb_cloudy, color: Colors.blueGrey, size: size);
    if (code <= 48) return Icon(Icons.foggy, color: Colors.grey, size: size);
    if (code <= 57) return Icon(Icons.grain, color: Colors.blue, size: size);
    if (code <= 67) return Icon(Icons.cloudy_snowing, color: Colors.blue, size: size);
    if (code <= 77) return Icon(Icons.ac_unit, color: Colors.lightBlue, size: size);
    if (code <= 82) return Icon(Icons.umbrella, color: Colors.blue, size: size);
    if (code <= 99) return Icon(Icons.thunderstorm, color: Colors.deepPurple, size: size);
    return Icon(Icons.help_outline, size: size);
  }

  String _getWeatherDescription(int code) {
    if (code == 0) return "Clear Sky";
    if (code <= 3) return "Partly Cloudy";
    if (code <= 48) return "Foggy";
    if (code <= 57) return "Drizzle";
    if (code <= 67) return "Rainy";
    if (code <= 77) return "Snowy";
    if (code <= 82) return "Rain Showers";
    if (code <= 99) return "Thunderstorm";
    return "Unknown";
  }
}
