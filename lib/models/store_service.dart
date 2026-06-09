import 'package:geolocator/geolocator.dart';
import '../../models/plant_store.dart';
import '../../models/store_repository.dart';

class StoreService {
  Future<PlantStore?> findNearestStore(Position userPosition) async {
    final stores = await StoreRepository.getPlantStores();
    final nearbyStores = stores.where((store) {
      final distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        store.latitude,
        store.longitude,
      );
      return distance <= 30000; // 30km radius
    }).toList();

    if (nearbyStores.isEmpty) return null;

    nearbyStores.sort((a, b) {
      final distA = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        a.latitude,
        a.longitude,
      );
      final distB = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        b.latitude,
        b.longitude,
      );
      return distA.compareTo(distB);
    });

    return nearbyStores.first;
  }
}
