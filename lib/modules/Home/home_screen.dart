import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:plantie/modules/Home/cubit/cubit.dart';
import 'package:plantie/modules/Home/cubit/states.dart';
import 'package:plantie/modules/Home/fertilizer_screen.dart';
import 'package:plantie/modules/Home/weather_details_screen.dart';
import 'package:plantie/shared/components/components.dart';
import 'package:plantie/shared/styles/colors.dart';
import 'package:shimmer/shimmer.dart';
import '../../layout/cubit/cubit.dart';
import '../../models/plant.dart';
import '../../models/weather_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = HomeCubit.get(context);
          final plants = cubit.plants;
          final hasPlants = plants.isNotEmpty;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 70.0, 15.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // weather card
                  _buildWeatherCard(context, state, cubit),
                  SizedBox(
                    height: 8,
                  ),
                  if (state is WeatherLoadedState)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Weather",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          cubit.weatherData!.weather[0].description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),

                  Text(
                    "Choose a Plant",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(
                    height: 130,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          buildPlantItem(index, cubit),
                      itemCount: 10,
                      separatorBuilder: (context, index) => SizedBox(
                        width: 18,
                      ),
                    ),
                  ),

                  if (hasPlants)
                    Text(
                      plants[cubit.selectedIndex].name,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  SizedBox(height: 15),

                  Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: plantieColor, // Light green color
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        final plant = plants[cubit.selectedIndex];

                        navigateTo(
                            context,
                            FertilizerScreen(
                              plant: PlantData(
                                name: plant.name,
                                type: plant.category,
                                npk: plant.npk,
                                emoji: cubit.plantEmojis[cubit.selectedIndex],
                              ),
                            ));
                      },
                      child: Text(
                        "Calculate Fertilizer",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  if (!hasPlants)
                    _buildLoadingShimmer()
                  else
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildPlantDetailCard(
                            context, plants[cubit.selectedIndex]),
                        const SizedBox(height: 20),
                        _buildDetailTabs(context, plants[cubit.selectedIndex]),
                      ],
                    ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildPlantItem(int index, cubit) {
    bool isSelected = index == cubit.selectedIndex;

    return GestureDetector(
      onTap: () {
        cubit.changeSelectedIndex(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            cubit.plantEmojis[index],
            style: TextStyle(
              fontSize: 65,
            ),
          ),
          const SizedBox(height: 5),
          if (isSelected)
            Container(
              width: 50,
              height: 2,
              color: plantieColor, // Underline for the selected plant
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Column(
      children: List.generate(
          3,
          (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              )),
    );
  }

  Widget _buildPlantDetailCard(BuildContext context, Plant plant) {
    return Card(
      color: AppCubit.get(context).isDark
          ? HexColor("1C1C1E")
          : HexColor("FFFFFF"),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.category,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: plantieColor,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        plant.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      HomeCubit.get(context)
                          .plantEmojis[HomeCubit.get(context).selectedIndex],
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.calendar_today, 'Planting Time',
                plant.plantingTime, context),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.eco, 'NPK Formula', plant.npk, context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTabs(BuildContext context, Plant plant) {
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            isScrollable: true,
            labelColor: plantieColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: plantieColor,
            tabs: const [
              Tab(text: 'Description'),
              Tab(text: 'Nutrition'),
              Tab(text: 'Storage'),
              Tab(text: 'Diseases'),
            ],
          ),
          SizedBox(
            height: 300,
            child: TabBarView(
              children: [
                _buildTabContent(Icons.description, plant.description),
                _buildNutritionContent(plant.nutritionRecommendations),
                _buildStorageContent(plant.storageInfo, context),
                _buildDiseaseContent(plant.diseaseAndPestControl, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Align items to the top for multi-line text
        children: [
          Icon(icon, color: plantieColor, size: 25),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleMedium,
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(IconData icon, String content) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: plantieColor, size: 32),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionContent(Map<String, String> nutrition) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: nutrition.entries
          .map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(entry.value),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildStorageContent(Map<String, String> storage, context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStorageItem('Temperature', storage['temperature']!, context),
        _buildStorageItem('Humidity', storage['humidity']!, context),
      ],
    );
  }

  Widget _buildStorageItem(String title, String value, context) {
    return Card(
      color: AppCubit.get(context).isDark
          ? HexColor("1C1C1E")
          : HexColor("FFFFFF"),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(Icons.storage, color: plantieColor),
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        subtitle: Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildDiseaseContent(List<Disease> diseases, context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: diseases.length,
      itemBuilder: (context, index) => Card(
        color: AppCubit.get(context).isDark
            ? HexColor("1C1C1E")
            : HexColor("FFFFFF"),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ExpansionTile(
          leading: Icon(Icons.health_and_safety, color: plantieColor),
          title: Text(
            diseases[index].name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prevention:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(diseases[index].prevention),
                  const SizedBox(height: 16),

                  CachedNetworkImage(imageUrl: diseases[index].imageURL),
                  // Image.asset(
                  //   'assets/${diseases[index].imageURL}',
                  //   width: double.infinity,
                  //   height: 150,
                  //   fit: BoxFit.cover,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(
      BuildContext context, HomeStates state, HomeCubit cubit) {
    return GestureDetector(
      onTap: () {
        if (cubit.weatherData != null) {
          navigateTo(
              context, WeatherDetailsScreen(weatherData: cubit.weatherData!));
        }
      },
      child: Container(
        height: 220,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: _getWeatherGradient(cubit.weatherData),
        ),
        child: _getWeatherContent(state, cubit, context),
      ),
    );
  }

  Widget _getWeatherContent(HomeStates state, HomeCubit cubit, context) {
    // Check for existing weather data first
    if (cubit.weatherData != null) {
      return _buildWeatherData(cubit.weatherData!, context);
    }

    if (state is WeatherLoadingState) {
      return _buildLoading();
    }
    if (state is LocationPermissionDeniedState) {
      return _buildPermissionDenied(cubit);
    }

    if (state is WeatherLoadedState) {
      return _buildWeatherData(cubit.weatherData!, context);
    }

    if (state is LocationPermanentlyDeniedState) {
      return _buildPermanentDenial(cubit);
    }
    if (state is LocationServicesDisabledState) {
      return _buildServicesDisabled(cubit);
    }
    if (state is WeatherFetchErrorState) {
      return _buildError(state.msg, cubit);
    }
    return _buildInitial(cubit);
  }

  Widget _buildWeatherData(WeatherData weather, BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                weather.weather.first.main,
                style: textStyle?.copyWith(fontSize: 14),
              ),
            ),
            const SizedBox(height: 12),
            Image.network(
              'https://openweathermap.org/img/wn/${weather.weather.first.icon}@2x.png',
              width: 100,
              height: 100,
            ),
          ],
        ),
        Container(
          width: 1,
          height: 150,
          color: Colors.white54,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${weather.name}, ${weather.sys.country}',
              style: textStyle?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('EEEE, MMM d').format(weather.lastUpdated),
              style: textStyle,
            ),
            const SizedBox(height: 12),
            Text(
              '${weather.main.temp.round()}°C',
              style: textStyle?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Feels like ${weather.main.feelsLike.round()}°C',
              style: textStyle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Fetching weather...',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDenied(HomeCubit cubit) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 40, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Location permission required',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          TextButton.icon(
            icon: Icon(Icons.location_on),
            label: Text(
              'Enable Location',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: cubit.requestLocationPermission,
          ),
        ],
      ),
    );
  }

  Widget _buildPermanentDenial(HomeCubit cubit) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 40, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Location permissions permanently denied. Please enable in settings.',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          TextButton.icon(
            icon: Icon(Icons.settings),
            label: Text(
              'Open Settings',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: cubit.openAppSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildServicesDisabled(HomeCubit cubit) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.gps_off, size: 40, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Location services disabled. Please enable GPS.',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          TextButton.icon(
            icon: Icon(Icons.gps_fixed),
            label: Text(
              'Enable GPS',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: cubit.openLocationSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error, HomeCubit cubit) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Error fetching weather: $error',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          TextButton.icon(
            icon: Icon(Icons.refresh),
            label: Text(
              'Try Again',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: cubit.getWeatherData,
          ),
        ],
      ),
    );
  }

  Widget _buildInitial(HomeCubit cubit) {
    return Center(
      child: TextButton.icon(
        icon: Icon(Icons.cloud),
        label: Text('Get Weather',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        onPressed: cubit.getWeatherData,
      ),
    );
  }

  LinearGradient _getWeatherGradient(WeatherData? weather) {
    final isSunny =
        weather?.weather.any((w) => w.main.contains('Clear')) ?? false;

    return isSunny
        ? LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFECB3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : LinearGradient(
            colors: [Color(0xFF6AA6FF), Color(0xFFBFDFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
  }
}
