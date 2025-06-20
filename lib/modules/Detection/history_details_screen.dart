import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../generated/l10n.dart';
import '../../models/history_item.dart';
import '../../models/plant_store.dart';
import '../../models/store_service.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/location_service.dart';
import '../../shared/styles/colors.dart';

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
            // Image preview
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
            // Details
            _buildDetailItem(S.of(context).name, item.title),
            _buildDetailItem(S.of(context).treatment, item.treatment),
            _buildDetailItem(S.of(context).tips, item.tips),
            _buildDetailItem(S.of(context).date, _formatDate(context, item.date)),
            const SizedBox(height: 10),
            // Map button
            _buildMapButton(context),
          ],
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    return DateFormat.yMMMMEEEEd(Localizations.localeOf(context).toString()).format(date);

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
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        color: plantieColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextButton(
        onPressed: () => _openNearestStore(context),
        child: Text(
          S.of(context).nearestNursery,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _openNearestStore(BuildContext context) async {
    try {
      await locationService.checkLocationPermission();
      final Position position = await locationService.getCurrentPosition();

      final nearest = await storeService.findNearestStore(position);

      if (nearest != null) {
        _launchMaps(nearest, position , context);
      } else {
        showToast(
            text: S.of(context).noStoresFound,
            state: ToastStates.error
        );
      }
    } catch (e) {
      showToast(
          text: S.of(context).locationError(e.toString()),
          state: ToastStates.error
      );
    }
  }

  void _launchMaps(PlantStore store, Position userPosition , context) async {
    final url = Platform.isAndroid
        ? 'https://www.google.com/maps/dir/?api=1&origin=${userPosition.latitude},${userPosition.longitude}&destination=${store.latitude},${store.longitude}&travelmode=driving'
        : 'http://maps.apple.com/?daddr=${store.latitude},${store.longitude}&saddr=${userPosition.latitude},${userPosition.longitude}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw S.of(context).launchError;
    }
  }
}