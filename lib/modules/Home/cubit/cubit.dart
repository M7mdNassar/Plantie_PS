import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plantie/modules/Home/cubit/states.dart';
import 'package:plantie/modules/Home/data/weather_repository.dart';
import 'package:plantie/modules/Home/domain/farming_insight.dart';
import 'package:plantie/modules/Home/domain/farming_service.dart';
import '../../../models/plant.dart';
import '../../../models/weather_model.dart';

// =====================================================================
// WEATHER CACHE CLASS (private, inside cubit file)
// =====================================================================
class _WeatherCache {
  WeatherData? data;
  DateTime? timestamp;
  static const Duration ttl = Duration(minutes: 30);

  bool get isValid => data != null && timestamp != null &&
      DateTime.now().difference(timestamp!) < ttl;

  void set(WeatherData weather) {
    data = weather;
    timestamp = DateTime.now();
  }

  void clear() {
    data = null;
    timestamp = null;
  }
}

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  final WeatherRepository _weatherRepository = WeatherRepository();
  List<FarmingInsight> insights = [];

  int selectedIndex = 0;

  void changeSelectedIndex(int index) {
    if (index >= 0 && index < plants.length) {
      selectedIndex = index;
      emit(HomeChangeSelectedIndexState());
    }
  }

  List<String> plantEmojis = [
    '🍎', // apple
    '🫘', // bean
    '🌽', // corn
    '🥒', // cucumber
    '🍇', // grapes
    '🫒', // olives
    '🌶️', // pepper
    '🥔', // potato
    '🍓', // strawberry
    '🍅' // tomato
  ];

  List<Plant> plants = [];

  Future<void> loadPlants() async {
    emit(HomeLoadingPlantsState());

    try {
      final String response =
      await rootBundle.loadString('assets/plants_data.json');
      final List<dynamic> data = jsonDecode(response);

      plants = data.map((plant) => Plant.fromJson(plant)).toList();

      emit(HomeGetPlantsSuccessState());
    } catch (e) {
      log("$e");
      emit(HomeGetPlantsErrorState());
    }
  }

  // ------------------------------------------------------------------
  // Weather caching (Issue 12)
  // ------------------------------------------------------------------
  final _WeatherCache _cache = _WeatherCache();

  WeatherData? weatherData;
  bool _isRequestingLocation = false;

  Future<void> getWeatherData() async {
    if (_isRequestingLocation) return;

    // 1. Check cache first
    if (_cache.isValid) {
      weatherData = _cache.data;
      emit(WeatherLoadedState());
      return;
    }

    emit(WeatherLoadingState());

    try {
      _isRequestingLocation = true;

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(LocationServicesDisabledState());
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(LocationPermissionDeniedState());
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(LocationPermanentlyDeniedState());
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );

      weatherData = await _weatherRepository.getWeatherData(
        position.latitude,
        position.longitude,
      );

      // Cache the result
      _cache.set(weatherData!);

      emit(WeatherLoadedState());
    } catch (e) {
      log("Weather Error: $e");
      emit(WeatherFetchErrorState(e.toString()));
    } finally {
      _isRequestingLocation = false;
    }
  }

  // Force refresh (bypass cache)
  Future<void> refreshWeather() async {
    _cache.clear();
    await getWeatherData();
  }

  void generateInsights(BuildContext context) {
    if (weatherData != null) {
      insights = FarmingService.getInsights(weatherData!, context);
    }
  }

  Future<void> requestLocationPermission() async {
    if (_isRequestingLocation) return;
    await getWeatherData();
  }

  Future<void> openAppSettings() async {
    if (_isRequestingLocation) return;
    await Geolocator.openAppSettings();
    await Future.delayed(const Duration(milliseconds: 500));
    await getWeatherData();
  }

  Future<void> openLocationSettings() async {
    if (_isRequestingLocation) return;
    await Geolocator.openLocationSettings();
    await Future.delayed(const Duration(milliseconds: 500));
    await getWeatherData();
  }
}