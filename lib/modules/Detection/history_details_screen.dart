import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/history_item.dart';
import '../../models/plant_store.dart';
import '../../models/store_service.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/location_service.dart';

class HistoryDetailScreen extends StatelessWidget {
  final HistoryItem item;
  final LocationService locationService = LocationService();
  final StoreService storeService = StoreService();

  HistoryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(item.imagePath),
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailItem('الاسم:', item.title),
            _buildDetailItem('العلاج:', item.treatment),
            _buildDetailItem('النصائح:', item.tips),
            _buildDetailItem('التاريخ:', _formatDate(item.date)),
            _buildMapButton(context),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.map),
        label: const Text('أقرب مشتل نباتات'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: () => _openNearestStore(context),
      ),
    );
  }

  Future<void> _openNearestStore(BuildContext context) async {
    try {
      // Check permissions and get location
      await locationService.checkLocationPermission();
      final Position position = await locationService.getCurrentPosition();

      // Find the nearest store
      final nearest = await storeService.findNearestStore(position);

      if (nearest != null) {
        _launchMaps(nearest, position);
      } else {
        showToast(text: 'No nearby stores found', state: ToastStates.error);
      }
    } catch (e) {
      showToast(text: 'Error: $e', state: ToastStates.error);
    }
  }

  void _launchMaps(PlantStore store, Position userPosition) async {
    final url = Platform.isAndroid
        ? 'https://www.google.com/maps/dir/?api=1&origin=${userPosition.latitude},${userPosition.longitude}&destination=${store.latitude},${store.longitude}&travelmode=driving'
        : 'http://maps.apple.com/?daddr=${store.latitude},${store.longitude}&saddr=${userPosition.latitude},${userPosition.longitude}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
