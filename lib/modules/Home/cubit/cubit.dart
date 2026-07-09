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
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/plant.dart';
import '../../../models/weather_model.dart';

// =====================================================================
// PERSISTENT WEATHER CACHE (SharedPreferences)
// =====================================================================
class _PersistentWeatherCache {
  static const String _cacheKey = 'cached_weather_data';
  static const Duration ttl = Duration(minutes: 30);

  static Future<void> save(WeatherData weather) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'weather': weather.toJson(),
      'timestamp': DateTime.now().toIso8601String(),
    };
    await prefs.setString(_cacheKey, jsonEncode(data));
  }

  static Future<WeatherData?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw);
      final timestamp = DateTime.parse(json['timestamp']);
      if (DateTime.now().difference(timestamp) > ttl) {
        // Expired – clear it
        await prefs.remove(_cacheKey);
        return null;
      }
      return WeatherData.fromJson(json['weather']);
    } catch (e) {
      return null;
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState()) {
    _loadCachedWeather();
  }

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
  // Weather – with persistent cache
  // ------------------------------------------------------------------
  WeatherData? weatherData;
  bool _isRequestingLocation = false;

  /// Load cached weather from SharedPreferences on startup
  Future<void> _loadCachedWeather() async {
    final cached = await _PersistentWeatherCache.load();
    if (cached != null) {
      weatherData = cached;
      emit(WeatherLoadedState());
      debugPrint('✅ Weather loaded from persistent cache');
    }
  }

  Future<void> getWeatherData() async {
    if (_isRequestingLocation) return;

    // Check persistent cache first
    final cached = await _PersistentWeatherCache.load();
    if (cached != null) {
      weatherData = cached;
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

      // Save to persistent cache
      await _PersistentWeatherCache.save(weatherData!);
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
    await _PersistentWeatherCache.clear(); // clear cached
    await getWeatherData();
  }

  // ============================================================
  // INSIGHTS – STABLE LIST REFERENCE (no flicker)
  // ============================================================
  void generateInsights(BuildContext context) {
    if (weatherData == null) return;

    final newInsights = FarmingService.getInsights(weatherData!, context);

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