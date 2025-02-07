import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/modules/Home/cubit/states.dart';
import '../../../models/plant.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int selectedIndex = 0; // Track selected plant index

  void changeSelectedIndex(int index) {
    selectedIndex = index;
    emit(HomeChangeSelectedIndexState());
  }

  List<Plant> plants = [];
  /// Note : this emojis mapping the same order in plant data file (JSON file)
  List<String> plantEmojis = [
    '🍎',  // apple
    '🫘',  // bean
    '🌽',  // corn
    '🥒',  // cucumber
    '🍇',  // grapes
    '🫒',  // olives
    '🌶️', // pepper
    '🥔',  // potato
    '🍓',  // strawberry
    '🍅'   // tomato
  ];

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
}
