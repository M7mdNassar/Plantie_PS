import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:plantie/models/history_item.dart';
import 'package:plantie/modules/Detection/history_details_screen.dart';
import 'package:plantie/shared/utils/animations.dart';

import '../../generated/l10n.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/app_colors.dart';
import '../../layout/cubit/cubit.dart';
import 'Classification/image_picker_handler.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class DetectionScreen extends StatelessWidget {
  const DetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetectionCubit, DetectionStates>(
      listener: (context, state) {
        if (state is DetectionErrorState) {
          showToast(text: state.message, state: ToastStates.error);
        }
      },
      builder: (context, state) {
        final cubit = DetectionCubit.get(context);
        final isDark = AppCubit.get(context).isDark;
        final textScale = MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.3);

        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : HexColor("F8F9FA"),
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App Bar
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  centerTitle: false,
                  title: Text(
                    S.of(context).plantDiagnosis ?? "Plant Diagnosis",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 24 * textScale,
                      letterSpacing: -0.5,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),

                // Dynamic Hero Section (with AnimatedSwitcher for smooth transitions)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    child: _buildDynamicHeroSection(context, state, cubit, isDark, textScale),
                  ),
                ),

                // History Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                    child: Text(
                      S.of(context).recentDiagnoses ?? "Recent Diagnoses",
                      style: TextStyle(
                        fontSize: 16 * textScale,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                        color: isDark ? Colors.grey[400] : Colors.grey[800],
                      ),
                    ),
                  ),
                ),

                // History List
                if (cubit.history.isEmpty)
                  SliverToBoxAdapter(
                    child: _buildEmptyHistory(context, isDark, textScale),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final item = cubit.history[index];
                          return FadeInAnimation(
                            duration: Duration(milliseconds: 50 * index.clamp(0, 10)),
                            child: _HistoryItemCard(item: item, isDark: isDark, textScale: textScale),
                          );
                        },
                        childCount: cubit.history.length,
                      ),
                    ),
                  ),

                const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the hero section with an AnimatedSwitcher to force UI rebuild on state change.
  Widget _buildDynamicHeroSection(
      BuildContext context,
      DetectionStates state,
      DetectionCubit cubit,
      bool isDark,
      double textScale,
      ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: _HeroContent(
        // Key changes whenever the state or result changes → forces rebuild
        key: ValueKey('${state.runtimeType}_${cubit.currentResult}_${cubit.currentImage?.path}'),
        state: state,
        cubit: cubit,
        isDark: isDark,
        textScale: textScale,
      ),
    );
  }

  Widget _buildEmptyHistory(BuildContext context, bool isDark, double textScale) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.history_rounded, size: 64, color: isDark ? Colors.grey[800] : Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              S.of(context).noHistoryYet ?? "No history yet",
              style: TextStyle(
                fontSize: 16 * textScale,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[600] : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extracted hero content widget to work with AnimatedSwitcher.
class _HeroContent extends StatelessWidget {
  final DetectionStates state;
  final DetectionCubit cubit;
  final bool isDark;
  final double textScale;

  const _HeroContent({
    required this.state,
    required this.cubit,
    required this.isDark,
    required this.textScale,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (state is DetectionLoadingState && cubit.currentImage != null) {
      return _ScanningAnimationCard(image: cubit.currentImage!, isDark: isDark);
    } else if (cubit.currentImage != null && (state is DetectionResultState || cubit.currentResult != null)) {
      return _ActiveResultCard(cubit: cubit, isDark: isDark, textScale: textScale);
    } else {
      return _HeroScanPrompt(isDark: isDark, textScale: textScale);
    }
  }
}

// ─────────────────────────────────────────────
//  Hero Scan Prompt (CTA)
// ─────────────────────────────────────────────
class _HeroScanPrompt extends StatelessWidget {
  final bool isDark;
  final double textScale;

  const _HeroScanPrompt({required this.isDark, required this.textScale});

  @override
  Widget build(BuildContext context) {
    return ScaleInAnimation(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColors.primaryLight, HexColor("2F6647")]
                : [AppColors.primary, HexColor("419A66")],
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppColors.primaryLight : AppColors.primary).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Icon(Icons.eco_rounded, size: 180, color: Colors.white.withValues(alpha: 0.1)),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.document_scanner_rounded, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    S.of(context).scanPlantPrompt ?? "Identify Plant Diseases",
                    style: TextStyle(
                      fontSize: 22 * textScale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    S.of(context).scanPlantSubPrompt ?? "Take a photo of a leaf to get an instant diagnosis and treatment plan.",
                    style: TextStyle(
                      fontSize: 14 * textScale,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => ImagePickerHandler.processImage(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      S.of(context).startScan ?? "Start Scan",
                      style: TextStyle(fontSize: 16 * textScale, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Loading / Scanning Card
// ─────────────────────────────────────────────
class _ScanningAnimationCard extends StatelessWidget {
  final File image;
  final bool isDark;

  const _ScanningAnimationCard({required this.image, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          image: DecorationImage(image: FileImage(image), fit: BoxFit.cover),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withValues(alpha: 0.4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  const SizedBox(height: 20),
                  Text(
                    S.of(context).analyzing ?? "Analyzing Image...",
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Active Result Card (Healthy / Diseased / Not a Plant)
// ─────────────────────────────────────────────
class _ActiveResultCard extends StatelessWidget {
  final DetectionCubit cubit;
  final bool isDark;
  final double textScale;

  const _ActiveResultCard({required this.cubit, required this.isDark, required this.textScale});

  @override
  Widget build(BuildContext context) {
    final isRejected = cubit.detectionRejected;
    final isHealthy = !isRejected && (cubit.orginalResult?.toLowerCase().contains('healthy') ?? false);

    final Color themeColor = isRejected
        ? Colors.grey[700]!
        : (isHealthy ? AppColors.success : AppColors.warning);

    final IconData statusIcon = isRejected
        ? Icons.not_interested_rounded
        : (isHealthy ? Icons.check_circle_rounded : Icons.warning_rounded);

    return ScaleInAnimation(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: themeColor.withValues(alpha: 0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: themeColor.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          children: [
            // Image Half
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                image: DecorationImage(image: FileImage(cubit.currentImage!), fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Row(
                      children: [
                        Icon(statusIcon, color: themeColor, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          isRejected
                              ? (S.of(context).notAPlant ?? "Not a Plant")
                              : (isHealthy ? (S.of(context).healthy ?? "Healthy") : (S.of(context).diseaseDetected ?? "Disease Detected")),
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16 * textScale),
                        ),
                      ],
                    ),
                  ),
                  if (cubit.detectionConfidence != null)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          "${(cubit.detectionConfidence! * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Details Half
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cubit.currentResult ?? "",
                    style: TextStyle(
                      fontSize: 18 * textScale,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      // Primary Action: View Details (only if plant and history exists)
                      if (!isRejected && cubit.history.isNotEmpty)
                        ElevatedButton(
                          onPressed: () => navigateTo(context, HistoryDetailScreen(item: cubit.history.first)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(
                            S.of(context).viewDetails ?? "Details",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16 * textScale),
                          ),
                        ),
                      const SizedBox(height: 12),
                      // Secondary Action: Scan Another
                      OutlinedButton.icon(
                        onPressed: () => ImagePickerHandler.processImage(context),
                        icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
                        label: Text(
                          S.of(context).scanAnother ?? "Scan Again",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 * textScale),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.white : AppColors.primary,
                          side: BorderSide(
                            color: isDark ? Colors.white38 : AppColors.primary.withValues(alpha: 0.3),
                          ),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  History Item Card
// ─────────────────────────────────────────────
class _HistoryItemCard extends StatelessWidget {
  final HistoryItem item;
  final bool isDark;
  final double textScale;

  const _HistoryItemCard({required this.item, required this.isDark, required this.textScale});

  @override
  Widget build(BuildContext context) {
    final isHealthy = item.diseaseKey.toLowerCase().contains('healthy');
    final Color badgeColor = isHealthy ? AppColors.success : AppColors.warning;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => navigateTo(context, HistoryDetailScreen(item: item)),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Hero(
                  tag: 'history-image-${item.id}',
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: FileImage(File(item.imagePath)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: badgeColor),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isHealthy ? (S.of(context).healthy ?? "Healthy") : (S.of(context).diseaseDetected ?? "Diseased"),
                            style: TextStyle(
                              fontSize: 11 * textScale,
                              fontWeight: FontWeight.bold,
                              color: badgeColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15 * textScale,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDateRelative(item.date, context),
                        style: TextStyle(
                          fontSize: 12 * textScale,
                          color: isDark ? Colors.grey[500] : Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: isDark ? Colors.grey[700] : Colors.grey[300]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateRelative(DateTime date, BuildContext context) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays == 0) return S.of(context).today ?? "Today";
    if (difference.inDays == 1) return S.of(context).yesterday ?? "Yesterday";
    return "${difference.inDays} ${S.of(context).daysAgo ?? "days ago"}";
  }
}