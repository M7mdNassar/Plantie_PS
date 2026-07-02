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
// WEATHER CACHE CLASS
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
  List<FarmingInsight> _cachedInsights = [];

  int selectedIndex = 0;

  void changeSelectedIndex(int index) {
    if (index >= 0 && index < plants.length) {
      selectedIndex = index;
      emit(HomeChangeSelectedIndexState());
    }
  }

  List<Plant> plants = [];

  Future<void> loadPlants() async {
    emit(HomeLoadingPlantsState());
    try {
      final String response = await rootBundle.loadString('assets/plants_data.json');
      final List<dynamic> data = jsonDecode(response);
      plants = data.map((e) => Plant.fromJson(e)).toList();
      if (selectedIndex >= plants.length) selectedIndex = 0;
      emit(HomeGetPlantsSuccessState());
    } catch (e) {
      log("$e");
      emit(HomeGetPlantsErrorState());
    }
  }

  // ------------------------------------------------------------------
  // Weather
  // ------------------------------------------------------------------
  final _WeatherCache _cache = _WeatherCache();

  WeatherData? weatherData;
  bool _isRequestingLocation = false;

  Future<void> getWeatherData() async {
    if (_isRequestingLocation) return;

    // Check cache
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

  // ============================================================
  // INSIGHTS – STABLE LIST REFERENCE (no flicker)
  // ============================================================
  void generateInsights(BuildContext context) {
    if (weatherData == null) return;

    final newInsights = FarmingService.getInsights(weatherData!, context);

    // Only update if content actually changed
    if (_insightsChanged(newInsights, _cachedInsights)) {
      _cachedInsights = newInsights;
      insights = _cachedInsights;
      emit(InsightsUpdatedState());
    }
  }

  bool _insightsChanged(List<FarmingInsight> newList, List<FarmingInsight> oldList) {
    if (newList.length != oldList.length) return true;
    for (int i = 0; i < newList.length; i++) {
      if (newList[i].title != oldList[i].title ||
          newList[i].message != oldList[i].message ||
          newList[i].level != oldList[i].level ||
          newList[i].icon != oldList[i].icon) {
        return true;
      }
    }
    return false;
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