import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'plant_store.dart';

class StoreRepository {
  static Future<List<PlantStore>> getPlantStores() async {
    final String response = await rootBundle.loadString('assets/plant_stores.json');
    final data = await json.decode(response) as List;
    return data.map((store) => PlantStore.fromJson(store)).toList();
  }
}