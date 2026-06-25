import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/modules/Home/cubit/cubit.dart';
import 'package:plantie/modules/Home/cubit/states.dart';
import 'package:plantie/modules/Home/fertilizer_screen.dart';
import 'package:plantie/modules/Home/weather_details_screen.dart';
import 'package:plantie/shared/components/components.dart';
import 'package:plantie/shared/styles/app_colors.dart';
import 'package:plantie/shared/styles/responsive_text.dart';
import 'package:plantie/shared/utils/animations.dart';
import 'package:plantie/modules/Home/domain/farming_insight.dart';
import 'package:shimmer/shimmer.dart';
import '../../generated/l10n.dart';
import '../../models/plant.dart';
import '../../models/weather_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = HomeCubit.get(context);

      if (cubit.plants.isEmpty) {
        cubit.loadPlants();
      }

      if (cubit.weatherData == null) {
        cubit.getWeatherData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
      current is HomeGetPlantsSuccessState ||
          current is HomeGetPlantsErrorState ||
          current is HomeLoadingPlantsState ||
          current is WeatherSuccessState ||
          current is WeatherLoadingState ||
          current is LocationServicesDisabledState ||
          current is LocationPermissionDeniedState ||
          current is LocationPermanentlyDeniedState ||
          current is HomeChangeSelectedIndexState,
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        final plants = cubit.plants;
        final hasPlants = plants.isNotEmpty;

        // ✅ Show error state if plants failed to load (Issue 13)
        if (state is HomeGetPlantsErrorState && plants.isEmpty) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).failedToLoadPlants,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        S.of(context).failedToLoadPlantsMessage,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => cubit.loadPlants(),
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(S.of(context).retry),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveText.padding(context, 16),
                  ResponsiveText.padding(context, 16),
                  ResponsiveText.padding(context, 16),
                  ResponsiveText.padding(context, 20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    SizedBox(height: ResponsiveText.padding(context, 20)),
                    _buildWeatherCard(context, state, cubit),
                    SizedBox(height: ResponsiveText.padding(context, 24)),
                    if (cubit.weatherData != null)
                      _buildWeatherDescription(context, cubit),
                    SizedBox(height: ResponsiveText.padding(context, 24)),
                    _buildChoosePlantHeader(context),
                    SizedBox(height: ResponsiveText.padding(context, 12)),
                    _buildPlantCarousel(context, cubit),
                    SizedBox(height: ResponsiveText.padding(context, 20)),
                    if (hasPlants) ...[
                      _buildPlantNameHeader(
                        context,
                        plants[cubit.selectedIndex],
                      ),
                      SizedBox(height: ResponsiveText.padding(context, 12)),
                      _buildCalculateButton(context, cubit, plants),
                      SizedBox(height: ResponsiveText.padding(context, 20)),
                      _buildPlantDetailCard(
                        context,
                        plants[cubit.selectedIndex],
                      ),
                      SizedBox(height: ResponsiveText.padding(context, 20)),
                      _PlantDetailsExpandable(
                        plant: plants[cubit.selectedIndex],
                        context: context,
                      ),
                    ] else
                      _buildLoadingShimmer(),
                    SizedBox(height: ResponsiveText.padding(context, 20)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // =====================================================================
  // All other methods (unchanged from original)
  // =====================================================================

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).home,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveText.headline(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveText.padding(context, 4)),
        Text(
          S.of(context).homeSubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: ResponsiveText.bodySmall(context),
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDescription(BuildContext context, HomeCubit cubit) {
    if (cubit.insights.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topInsight = cubit.insights.first;
    final Color levelColor = topInsight.level == InsightLevel.critical
        ? AppColors.error
        : (topInsight.level == InsightLevel.warning
        ? AppColors.warning
        : AppColors.success);

    return Container(
      padding: EdgeInsets.all(ResponsiveText.padding(context, 12)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: levelColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: levelColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            topInsight.icon,
            color: levelColor,
            size: ResponsiveText.iconSizeSmall(context),
          ),
          SizedBox(width: ResponsiveText.padding(context, 8)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topInsight.title,
                  style: TextStyle(
                    fontSize: ResponsiveText.labelSmall(context),
                    fontWeight: FontWeight.bold,
                    color: levelColor,
                  ),
                ),
                Text(
                  topInsight.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: ResponsiveText.bodySmall(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoosePlantHeader(BuildContext context) {
    return Text(
      S.of(context).choosePlant,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: ResponsiveText.title(context),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildPlantNameHeader(BuildContext context, Plant plant) {
    return Text(
      plant.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: ResponsiveText.title(context),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCalculateButton(
      BuildContext context, HomeCubit cubit, List<Plant> plants) {
    return SizedBox(
      width: double.infinity,
      height: (48 * ResponsiveText.getScale(context)).clamp(44.0, 56.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          final plant = plants[cubit.selectedIndex];
          navigateTo(
            context,
            FertilizerScreen(
              plant: PlantData(
                name: plant.name,
                type: plant.category,
                npk: plant.npk,
                emoji: cubit.plantEmojis[cubit.selectedIndex],
              ),
            ),
          );
        },
        icon: const Icon(Icons.calculate, size: 18),
        label: Text(
          S.of(context).calculateFertilizer,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveText.body(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPlantCarousel(BuildContext context, HomeCubit cubit) {
    final emojiSize = ResponsiveText.emojiSmall(context);
    final carouselHeight = (emojiSize + 32).clamp(110.0, 160.0);
    final padding = ResponsiveText.padding(context, 12);
    final edgeInset = ResponsiveText.padding(context, 4);
    final plantsCount = cubit.plants.isNotEmpty ? cubit.plants.length : cubit.plantEmojis.length;

    return SizedBox(
      height: carouselHeight,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: edgeInset),
        itemBuilder: (context, index) =>
            _buildPlantItemOptimized(context, index, cubit, emojiSize),
        itemCount: plantsCount,
        separatorBuilder: (context, index) => SizedBox(width: padding),
        physics: const BouncingScrollPhysics(),
      ),
    );
  }

  Widget _buildPlantItemOptimized(
      BuildContext context, int index, dynamic cubit, double emojiSize) {
    bool isSelected = index == cubit.selectedIndex;

    return GestureDetector(
      onTap: () => cubit.changeSelectedIndex(index),
      child: AnimatedScale(
        scale: isSelected ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: _buildEmojiCard(context, cubit, index, isSelected, emojiSize),
      ),
    );
  }

  Widget _buildEmojiCard(BuildContext context, dynamic cubit, int index,
      bool isSelected, double emojiSize) {
    final padding = ResponsiveText.padding(context, 12);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(padding * 0.75),
          constraints: BoxConstraints(
            minWidth: emojiSize + padding,
            minHeight: emojiSize + padding,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              cubit.plantEmojis[index],
              style: TextStyle(fontSize: emojiSize),
              textScaler: TextScaler.noScaling,
            ),
          ),
        ),
        if (isSelected)
          Padding(
            padding: EdgeInsets.only(top: ResponsiveText.padding(context, 6)),
            child: Container(
              width: (emojiSize * 0.6).clamp(20.0, 40.0),
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return Column(
      children: List.generate(
          3,
              (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildPlantDetailCard(BuildContext context, Plant plant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
            isDark ? AppColors.shadowColorDark : AppColors.shadowColorLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(ResponsiveText.padding(context, 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveText.padding(context, 8),
                        vertical: ResponsiveText.padding(context, 4),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        plant.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveText.labelSmall(context),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveText.padding(context, 8)),
                    Text(
                      plant.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: ResponsiveText.title(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: ResponsiveText.padding(context, 12)),
              Container(
                width:
                (70 * ResponsiveText.getScale(context)).clamp(60.0, 80.0),
                height:
                (70 * ResponsiveText.getScale(context)).clamp(60.0, 80.0),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  HomeCubit.get(context)
                      .plantEmojis[HomeCubit.get(context).selectedIndex],
                  style: TextStyle(
                    fontSize: ResponsiveText.emojiSmall(context),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveText.padding(context, 16)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today,
                  color: AppColors.primary,
                  size: ResponsiveText.iconSizeSmall(context)),
              SizedBox(width: ResponsiveText.padding(context, 8)),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${S.of(context).plantingTime}: ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: ResponsiveText.label(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: plant.plantingTime,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: ResponsiveText.label(context),
                        ),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveText.padding(context, 8)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.eco,
                  color: AppColors.primary,
                  size: ResponsiveText.iconSizeSmall(context)),
              SizedBox(width: ResponsiveText.padding(context, 8)),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${S.of(context).npkFormula}: ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: ResponsiveText.label(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: plant.npk,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: ResponsiveText.label(context),
                        ),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(
      BuildContext context,
      HomeStates state,
      HomeCubit cubit,
      ) {
    final scale = ResponsiveText.getScale(context);
    final minHeight = (140 * scale).clamp(120.0, 180.0);

    return GestureDetector(
      onTap: () {
        if (cubit.weatherData != null) {
          cubit.generateInsights(context);
          navigateTo(
            context,
            WeatherDetailsScreen(weatherData: cubit.weatherData!),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).grantLocationPermission),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(ResponsiveText.padding(context, 16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: _getWeatherGradient(cubit.weatherData),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: _getWeatherContent(state, cubit, context),
      ),
    );
  }

  Widget _getWeatherContent(
      HomeStates state, HomeCubit cubit, BuildContext context) {
    if (cubit.weatherData != null) {
      if (cubit.insights.isEmpty) {
        cubit.generateInsights(context);
      }
      return _buildWeatherData(cubit.weatherData!, cubit.insights, context);
    }

    if (state is WeatherLoadingState) {
      return _buildLoading(context);
    }

    if (state is LocationPermissionDeniedState) {
      return _buildPermissionDenied(cubit, context);
    }

    if (state is LocationPermanentlyDeniedState) {
      return _buildPermanentDenial(cubit, context);
    }

    if (state is LocationServicesDisabledState) {
      return _buildServicesDisabled(cubit, context);
    }

    if (state is WeatherFetchErrorState) {
      return _buildError(state.msg, cubit, context);
    }

    return _buildInitial(cubit, context);
  }

  Widget _buildLoading(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
        SizedBox(height: ResponsiveText.padding(context, 12)),
        Text(
          S.of(context).fetchingWeather,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveText.bodySmall(context),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionDenied(HomeCubit cubit, BuildContext context) {
    return _buildWeatherError(
      context,
      icon: Icons.location_off,
      message: S.of(context).locationDenied,
      buttonText: S.of(context).allowAccess,
      onPressed: () => cubit.requestLocationPermission(),
    );
  }

  Widget _buildPermanentDenial(HomeCubit cubit, BuildContext context) {
    return _buildWeatherError(
      context,
      icon: Icons.settings,
      message: S.of(context).permanentDenial,
      buttonText: S.of(context).openSettings,
      onPressed: () => cubit.openAppSettings(),
    );
  }

  Widget _buildServicesDisabled(HomeCubit cubit, BuildContext context) {
    return _buildWeatherError(
      context,
      icon: Icons.location_disabled,
      message: S.of(context).gpsDisabled,
      buttonText: S.of(context).enableGPS,
      onPressed: () => cubit.openLocationSettings(),
    );
  }

  Widget _buildError(String msg, HomeCubit cubit, BuildContext context) {
    return _buildWeatherError(
      context,
      icon: Icons.error_outline,
      message: S.of(context).weatherErrorTitle,
      buttonText: S.of(context).tryAgain,
      onPressed: () => cubit.getWeatherData(),
    );
  }

  Widget _buildInitial(HomeCubit cubit, BuildContext context) {
    return _buildWeatherError(
      context,
      icon: Icons.cloud_outlined,
      message: S.of(context).checkWeatherPrompt,
      buttonText: S.of(context).getWeather,
      onPressed: () => cubit.getWeatherData(),
    );
  }

  Widget _buildWeatherError(
      BuildContext context, {
        required IconData icon,
        required String message,
        required String buttonText,
        required VoidCallback onPressed,
      }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: ResponsiveText.iconSizeMedium(context)),
        SizedBox(height: ResponsiveText.padding(context, 8)),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveText.body(context),
          ),
        ),
        SizedBox(height: ResponsiveText.padding(context, 12)),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveText.label(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherData(WeatherData weather, List<FarmingInsight> insights,
      BuildContext context) {
    final scale = ResponsiveText.getScale(context);
    final statusColor = insights.isEmpty
        ? AppColors.success
        : (insights.any((i) => i.level == InsightLevel.critical)
        ? AppColors.error
        : AppColors.warning);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            '${weather.current.temperature.round()}°',
            style: TextStyle(
              fontSize: (48 * scale).clamp(40.0, 56.0),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: ResponsiveText.padding(context, 4)),
        Flexible(
          child: Text(
            _getWeatherDescription(context, weather.current.weatherCode),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveText.body(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: ResponsiveText.padding(context, 12)),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveText.padding(context, 12),
              vertical: ResponsiveText.padding(context, 6),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: ResponsiveText.padding(context, 6)),
                Flexible(
                  child: Text(
                    insights.isEmpty
                        ? S.of(context).good_for_farming
                        : (insights.any((i) => i.level == InsightLevel.critical)
                        ? S.of(context).critical_farming
                        : S.of(context).warning_farming),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveText.labelSmall(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getWeatherDescription(BuildContext context, int code) {
    if (code == 0) return S.of(context).clearSky;
    if (code <= 3) return S.of(context).partlyCloudy;
    if (code <= 48) return S.of(context).foggy;
    if (code <= 57) return S.of(context).drizzle;
    if (code <= 67) return S.of(context).rainy;
    if (code <= 77) return S.of(context).snowy;
    if (code <= 82) return S.of(context).rainShowers;
    if (code <= 99) return S.of(context).thunderstorm;
    return S.of(context).unknownDisease;
  }

  LinearGradient _getWeatherGradient(WeatherData? weather) {
    if (weather == null) {
      return LinearGradient(
        colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
      );
    }
    final isSunny = weather.current.weatherCode == 0;

    return isSunny
        ? LinearGradient(
      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    )
        : LinearGradient(
      colors: [Color(0xFF4B79A1), Color(0xFF283E51)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

// =====================================================================
// PlantDetailsExpandable (unchanged)
// =====================================================================
class _PlantDetailsExpandable extends StatefulWidget {
  final Plant plant;
  final BuildContext context;

  const _PlantDetailsExpandable({
    required this.plant,
    required this.context,
  });

  @override
  _PlantDetailsExpandableState createState() => _PlantDetailsExpandableState();
}

class _PlantDetailsExpandableState extends State<_PlantDetailsExpandable>
    with TickerProviderStateMixin {
  late List<bool> _expandedStates;
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _expandedStates = [false, false, false, false];
    _controllers = List.generate(
      4,
          (index) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleExpanded(int index) {
    setState(() {
      _expandedStates[index] = !_expandedStates[index];
      if (_expandedStates[index]) {
        _controllers[index].forward();
      } else {
        _controllers[index].reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sections = [
      {
        'title': S.of(context).description,
        'icon': Icons.description,
        'color': const Color(0xFF4CAF50),
        'content': widget.plant.description,
      },
      {
        'title': S.of(context).nutrition,
        'icon': Icons.fastfood,
        'color': const Color(0xFFFF9800),
        'content': widget.plant.nutritionRecommendations,
      },
      {
        'title': S.of(context).storage,
        'icon': Icons.storage,
        'color': const Color(0xFF2196F3),
        'content': widget.plant.storageInfo,
      },
      {
        'title': S.of(context).diseases,
        'icon': Icons.health_and_safety,
        'color': const Color(0xFFF44336),
        'content': widget.plant.diseaseAndPestControl,
      },
    ];

    return FadeInAnimation(
      duration: AnimationConstants.normalDuration,
      child: Column(
        children: List.generate(4, (index) {
          final section = sections[index];
          final color = section['color'] as Color;
          final isExpanded = _expandedStates[index];

          return Padding(
            padding: EdgeInsets.only(
              bottom: ResponsiveText.padding(context, 12),
            ),
            child: _buildExpandableCard(
              context: context,
              index: index,
              title: section['title'] as String,
              icon: section['icon'] as IconData,
              color: color,
              isDark: isDark,
              isExpanded: isExpanded,
              animation: _controllers[index],
              onTap: () => _toggleExpanded(index),
              plant: widget.plant,
              sectionData: section['content'],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildExpandableCard({
    required BuildContext context,
    required int index,
    required String title,
    required IconData icon,
    required Color color,
    required bool isDark,
    required bool isExpanded,
    required AnimationController animation,
    required VoidCallback onTap,
    required Plant plant,
    required dynamic sectionData,
  }) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              isDark
                  ? (color).withValues(alpha: 0.08)
                  : (color).withValues(alpha: 0.04),
              isDark ? Colors.grey[800]! : Colors.grey[50]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: color.withValues(alpha: isExpanded ? 0.3 : 0.1),
            width: 1,
          ),
          boxShadow: [
            if (isExpanded)
              BoxShadow(
                color: color.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(ResponsiveText.padding(context, 16)),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            color.withValues(alpha: 0.3),
                            color.withValues(alpha: 0.1)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          color: color,
                          size: 24,
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveText.padding(context, 12)),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: ResponsiveText.title(context),
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 400),
                      child: Icon(
                        Icons.expand_more,
                        color: color,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              if (isExpanded)
                Container(
                  padding: EdgeInsets.fromLTRB(
                    ResponsiveText.padding(context, 16),
                    0,
                    ResponsiveText.padding(context, 16),
                    ResponsiveText.padding(context, 16),
                  ),
                  child: _buildSectionContent(
                    context: context,
                    index: index,
                    sectionData: sectionData,
                    color: color,
                    isDark: isDark,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContent({
    required BuildContext context,
    required int index,
    required dynamic sectionData,
    required Color color,
    required bool isDark,
  }) {
    if (index == 0) {
      return _buildDescriptionContent(context, sectionData as String, isDark);
    } else if (index == 1) {
      return _buildNutritionContent(
          context, sectionData as Map<String, String>, color, isDark);
    } else if (index == 2) {
      return _buildStorageContent(
          context, sectionData as Map<String, String>, color, isDark);
    } else {
      return _buildDiseasesContent(context, sectionData, color, isDark);
    }
  }

  Widget _buildDescriptionContent(
      BuildContext context, String content, bool isDark) {
    return Text(
      content,
      style: TextStyle(
        fontSize: ResponsiveText.body(context),
        height: 1.8,
        color: isDark ? Colors.grey[300] : Colors.grey[700],
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildNutritionContent(
      BuildContext context,
      Map<String, dynamic> nutrition,
      Color color,
      bool isDark,
      ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;

        return Column(
          children: nutrition.entries.map((entry) {
            final valueText = entry.value.toString();
            final labelText = _localizedPlantLabel(context, entry.key.toString());

            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveText.padding(context, 8),
              ),
              child: isCompact
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                      ),
                      SizedBox(width: ResponsiveText.padding(context, 10)),
                      Expanded(
                        child: Text(
                          labelText,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: ResponsiveText.label(context),
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.grey[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveText.padding(context, 6)),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveText.padding(context, 10),
                          vertical: ResponsiveText.padding(context, 6),
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          valueText,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: ResponsiveText.labelSmall(context),
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: EdgeInsets.only(
                      top: ResponsiveText.padding(context, 6),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                  ),
                  SizedBox(width: ResponsiveText.padding(context, 10)),
                  Expanded(
                    child: Text(
                      labelText,
                      maxLines: 2,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: ResponsiveText.label(context),
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.grey[900],
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveText.padding(context, 8)),
                  Flexible(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * 0.42,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveText.padding(context, 10),
                          vertical: ResponsiveText.padding(context, 4),
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          valueText,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ResponsiveText.labelSmall(context),
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildStorageContent(
      BuildContext context,
      Map<String, dynamic> storage,
      Color color,
      bool isDark,
      ) {
    return Column(
      children: storage.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveText.padding(context, 10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _localizedPlantLabel(context, entry.key.toString()),
                style: TextStyle(
                  fontSize: ResponsiveText.labelSmall(context),
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: ResponsiveText.padding(context, 6)),
              Text(
                entry.value.toString(),
                style: TextStyle(
                  fontSize: ResponsiveText.body(context),
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _localizedPlantLabel(BuildContext context, String key) {
    final normalizedKey = key.trim().toLowerCase();

    switch (normalizedKey) {
      case 'nitrogen':
        return S.of(context).nitrogen;
      case 'phosphorus':
        return S.of(context).phosphorus;
      case 'potassium':
        return S.of(context).potassium;
      case 'temperature':
        return S.of(context).temperature;
      case 'humidity':
        return S.of(context).humidity;
      default:
        return key;
    }
  }

  Widget _buildDiseasesContent(
      BuildContext context,
      dynamic diseasesData,
      Color color,
      bool isDark,
      ) {
    final diseases = diseasesData is Iterable ? diseasesData.toList() : [];

    if (diseases.isEmpty) {
      return Center(
        child: Text(
          S.of(context).noDiseases,
          style: TextStyle(
            fontSize: ResponsiveText.body(context),
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Column(
      children: diseases.asMap().entries.map((entry) {
        final isLast = entry.key == diseases.length - 1;
        final disease = entry.value;
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveText.padding(context, 10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        size: 16,
                        color: color,
                      ),
                      SizedBox(width: ResponsiveText.padding(context, 8)),
                      Expanded(
                        child: Text(
                          disease.name ?? 'Unknown',
                          style: TextStyle(
                            fontSize: ResponsiveText.label(context),
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.grey[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveText.padding(context, 6)),
                  Text(
                    disease.prevention ?? '',
                    style: TextStyle(
                      fontSize: ResponsiveText.bodySmall(context),
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            if (!isLast)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveText.padding(context, 6),
                ),
                child: Container(
                  height: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[200],
                ),
              ),
          ],
        );
      }).toList(),
    );
  }
}