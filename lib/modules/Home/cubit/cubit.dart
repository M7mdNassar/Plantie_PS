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

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  final WeatherRepository _weatherRepository = WeatherRepository();
  List<FarmingInsight> insights = [];

  int selectedIndex = 0; // Track selected plant index

  void changeSelectedIndex(int index) {
    // Bounds checking - ensure index is within valid range
    if (index >= 0 && index < plants.length) {
      selectedIndex = index;
      emit(HomeChangeSelectedIndexState());
    }
  }

  /// Note : this emojis mapping the same order in plant data file (JSON file)
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

  WeatherData? weatherData;
  bool _isRequestingLocation = false; // Prevent duplicate requests

  Future<void> getWeatherData() async {
    // Prevent concurrent requests
    if (_isRequestingLocation) return;

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

      // Generate insights immediately after loading weather data
      emit(WeatherLoadedState());
    } catch (e) {
      log("Weather Error: $e");
      emit(WeatherFetchErrorState(e.toString()));
    } finally {
      _isRequestingLocation = false;
    }
  }

  void generateInsights(BuildContext context) {
    if (weatherData != null) {
      insights = FarmingService.getInsights(weatherData!, context);
    }
  }

  Future<void> requestLocationPermission() async {
    if (_isRequestingLocation) return; // Prevent duplicate requests
    await getWeatherData();
  }

  Future<void> openAppSettings() async {
    if (_isRequestingLocation) return; // Prevent duplicate requests
    await Geolocator.openAppSettings();
    // Wait a moment for user to grant permissions in settings
    await Future.delayed(const Duration(milliseconds: 500));
    await getWeatherData();
  }

  Future<void> openLocationSettings() async {
    if (_isRequestingLocation) return; // Prevent duplicate requests
    await Geolocator.openLocationSettings();
    // Wait a moment for user to enable location services
    await Future.delayed(const Duration(milliseconds: 500));
    await getWeatherData();
  }
}
