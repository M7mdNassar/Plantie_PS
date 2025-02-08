import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plantie/modules/Home/cubit/states.dart';
import '../../../models/plant.dart';
import '../../../models/weather_model.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int selectedIndex = 0; // Track selected plant index

  void changeSelectedIndex(int index) {
    selectedIndex = index;
    emit(HomeChangeSelectedIndexState());
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

  Future<void> getWeatherData() async {
    emit(WeatherLoadingState());

    try {
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

      final position = await Geolocator.getCurrentPosition();
      final response = await Dio().get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'lat': position.latitude,
          'lon': position.longitude,
          'appid': '490e6c9470a33b93bedb927c4543f36e',
          'units': 'metric',
        },
      );

      weatherData = WeatherData.fromJson(response.data);
      emit(WeatherLoadedState());
    } catch (e) {
      emit(WeatherFetchErrorState(e.toString()));
    }
  }

  Future<void> requestLocationPermission() async {
    await getWeatherData();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
    await getWeatherData();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
    await getWeatherData();
  }
}
