import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:plantie/layout/cubit/cubit.dart';
import 'package:plantie/modules/Detection/cubit/cubit.dart';
import '../../generated/l10n.dart';
import '../../models/disease_info.dart';
import '../../models/history_item.dart';
import '../../models/plant_store.dart';
import '../../models/store_service.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/location_service.dart';
import '../../shared/network/remote/supabase_auth_service.dart';
import '../../shared/styles/app_colors.dart';

class HistoryDetailScreen extends StatefulWidget {
  final HistoryItem item;

  const HistoryDetailScreen({super.key, required this.item});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  final LocationService locationService = LocationService();
  final StoreService storeService = StoreService();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppCubit.get(context).isDark;
    final diseaseKey = widget.item.diseaseKey;
    final diseaseData = DiseaseInfo.getData(diseaseKey);
    final isHealthy = widget.item.isHealthy;
    final languageCode = Localizations.localeOf(context).languageCode;

    // ─── Localized plant name ──────────────────────────────────
    final plantName = widget.item.getPlantDisplayName(languageCode);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: _buildCustomAppBar(context, isDark),
      body: FadeTransition(
        opacity: _fadeController.view,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildImageSection(context, isDark),
              _buildContentSection(context, isDark, diseaseData, isHealthy, plantName),
              // Extra bottom space to ensure content clears bottom bar
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context, bool isDark) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return AppBar(
      elevation: 0,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.item.getLocalizedName(languageCode),
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded),
          onPressed: () => _showEnhancedDeleteBottomSheet(context),
          color: AppColors.error,
        ),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context, bool isDark) {
    final isHealthy = widget.item.isHealthy;

    return Stack(
      children: [
        Container(
          height: 360,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _openFullImage(context),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    child: Hero(
                      tag: 'history-image-${widget.item.id}',
                      child: Image.file(
                        File(widget.item.imagePath),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 24,
          right: 24,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isHealthy
                  ? AppColors.success.withValues(alpha: 0.85)
                  : AppColors.warning.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (isHealthy ? AppColors.success : AppColors.warning)
                      .withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isHealthy ? Icons.check_circle : Icons.warning_amber,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  isHealthy ? S.of(context).healthy : S.of(context).diseaseDetected,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection(
      BuildContext context,
      bool isDark,
      DiseaseData? diseaseData,
      bool isHealthy,
      String plantName,
      ) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Plant Name ───
            if (plantName.isNotEmpty)
              _buildInfoCard(
                context,
                isDark,
                icon: Icons.eco,
                title: S.of(context).plantName,
                subtitle: plantName,
                iconColor: AppColors.primary,
              ),
            if (plantName.isNotEmpty) const SizedBox(height: 16),

            // ─── Disease Name ───
            _buildInfoCard(
              context,
              isDark,
              icon: Icons.healing,
              title: S.of(context).detectionResult,
              subtitle: widget.item.getLocalizedName(languageCode),
              iconColor: isHealthy ? AppColors.success : AppColors.warning,
            ),
            const SizedBox(height: 16),

            // ─── Treatment ───
            if (!isHealthy) ...[
              _buildExpandableCard(
                context,
                isDark,
                icon: Icons.medication,
                title: S.of(context).recommendedTreatment,
                content: widget.item.treatment,
                iconColor: AppColors.primary,
              ),
              const SizedBox(height: 16),
            ],

            // ─── Tips ───
            if (!isHealthy) ...[
              _buildExpandableCard(
                context,
                isDark,
                icon: Icons.lightbulb,
                title: S.of(context).expertAdvice,
                content: widget.item.getLocalizedTips(languageCode),
                iconColor: AppColors.tertiary,
              ),
              const SizedBox(height: 16),
            ],

            // ─── Date ───
            _buildInfoCard(
              context,
              isDark,
              icon: Icons.calendar_today,
              title: S.of(context).date,
              subtitle: _formatDate(context, widget.item.date),
              iconColor: AppColors.primary,
            ),
            const SizedBox(height: 24),

            // ─── Find Store Button (only if not healthy) ───
            if (!isHealthy) ...[
              _buildFindStoreButton(context),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context,
      bool isDark, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color iconColor,
      }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? AppColors.darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey[300]!)
                .withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: 2,
          )
        ],
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableCard(
      BuildContext context,
      bool isDark, {
        required IconData icon,
        required String title,
        required String content,
        required Color iconColor,
      }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (value * 0.05),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? AppColors.darkSurface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.grey[300]!)
                  .withValues(alpha: 0.08),
              blurRadius: 12,
              spreadRadius: 2,
            )
          ],
          border: Border.all(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Enhanced Find Store Button ────────────────────────────────

  Widget _buildFindStoreButton(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Material(
          child: InkWell(
            onTap: () => _openNearestStore(context),
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: AppColors.greenGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.storefront_outlined, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    s.findNearestStore,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                ],
              ),
            ),
          ),
        ),
        // Extra space below the button to prevent clipping
        const SizedBox(height: 12),
      ],
    );
  }

  // ─── Other methods ─────────────────────────────────────────────

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: const Icon(
        Icons.image,
        color: AppColors.primary,
        size: 48,
      ),
    );
  }

  void _openFullImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: Hero(
              tag: 'history-image-${widget.item.id}',
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Image.file(
                  File(widget.item.imagePath),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEnhancedDeleteBottomSheet(BuildContext context) {
    final isDark = AppCubit.get(context).isDark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, _) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_sweep_rounded,
                        color: AppColors.error,
                        size: 32,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                S.of(context).confirmDelete,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '${S.of(context).deleteConfirmation}\n\n"${widget.item.getLocalizedName(Localizations.localeOf(context).languageCode)}"',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            S.of(context).cancel,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Material(
                      child: InkWell(
                        onTap: () => _deleteWithAnimation(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.error,
                                AppColors.error.withValues(alpha: 0.8),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.error.withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Text(
                            S.of(context).delete,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteWithAnimation(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );

    DetectionCubit.get(context)
        .deleteHistoryItem(widget.item.id, widget.item.imagePath)
        .then((_) {
      if (context.mounted) {
        Navigator.pop(context);
        showToast(
          text: S.of(context).deletedSuccessfully,
          state: ToastStates.success,
        );
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    }).catchError((error) {
      if (context.mounted) {
        Navigator.pop(context);
        showToast(
          text: S.of(context).errorOccurred(error.toString()),
          state: ToastStates.error,
        );
      }
    });
  }

  String _formatDate(BuildContext context, DateTime date) {
    return DateFormat.yMMMMEEEEd(
      Localizations.localeOf(context).toString(),
    ).format(date);
  }

  // ─── Enhanced store locator with permission handling ──────────

  Future<void> _openNearestStore(BuildContext context) async {
    final s = S.of(context);

    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationSettingsDialog(
          context,
          title: S.of(context).locationServicesDisabledTitle,
          message: S.of(context).locationServicesDisabledMessage,
          buttonText: S.of(context).openSettings,
          onPressed: () => Geolocator.openLocationSettings(),
        );
        return;
      }

      // Check permission
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final newPermission = await Geolocator.requestPermission();
        if (newPermission == LocationPermission.denied) {
          _showLocationSettingsDialog(
            context,
            title: S.of(context).locationDeniedTitle,
            message: S.of(context).locationDeniedMessage,
            buttonText: S.of(context).openSettings,
            onPressed: () => Geolocator.openAppSettings(),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationSettingsDialog(
          context,
          title: S.of(context).locationPermanentlyDeniedTitle,
          message: S.of(context).locationPermanentlyDeniedMessage,
          buttonText: S.of(context).openSettings,
          onPressed: () => Geolocator.openAppSettings(),
        );
        return;
      }

      // Permission granted – get position
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );

      final nearest = await storeService.findNearestStore(position);

      if (!context.mounted) return;

      if (nearest != null) {
        // ✅ Check internet before launching maps
        final hasInternet = await SupabaseAuthService().isConnectedFast();
        if (!hasInternet) {
          _showOfflineDialog(context);
          return;
        }
        _launchMaps(nearest, position, context);
      } else {
        showToast(
          text: S.of(context).noStoresFound,
          state: ToastStates.error,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      showToast(
        text: S.of(context).locationError(e.toString()),
        state: ToastStates.error,
      );
    }
  }

  void _showLocationSettingsDialog(
      BuildContext context, {
        required String title,
        required String message,
        required String buttonText,
        required VoidCallback onPressed,
      }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        title: Row(
          children: [
            Icon(Icons.location_off, color: AppColors.error),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onPressed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  void _showOfflineDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        title: Row(
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(S.of(ctx).noInternetConnection),
          ],
        ),
        content: Text(S.of(ctx).offlineMapMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(ctx).ok),
          ),
        ],
      ),
    );
  }

  Future<void> _launchMaps(PlantStore store, Position userPosition, BuildContext context) async {
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