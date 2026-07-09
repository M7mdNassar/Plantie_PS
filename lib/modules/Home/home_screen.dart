import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plantie/config/app_config.dart';
import 'package:plantie/config/config_manager.dart';
import 'package:plantie/modules/Home/cubit/cubit.dart';
import 'package:plantie/modules/Home/cubit/states.dart';
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
import '../../shared/network/remote/supabase_auth_service.dart';
import '../AIAssistant/ai_chat_screen.dart';

// ─────────────────────────────────────────────────────────────
//  HomeScreen – main widget
// ─────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;

  bool _permissionChecked = false;
  bool _permissionGranted = false;
  bool _permissionPermanentlyDenied = false;

  bool _isCheckingWeather = true;
  bool _isOffline = false;

  static DateTime? _lastConfigFetch;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = HomeCubit.get(context);
      if (cubit.plants.isEmpty) cubit.loadPlants();
      _checkLocationPermission();
      _checkWeatherConfig();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Config check with cooldown ──────────────────────────

  Future<void> _checkWeatherConfig() async {
    if (_lastConfigFetch != null &&
        DateTime.now().difference(_lastConfigFetch!) < const Duration(minutes: 10)) {
      final hasInternet = await SupabaseAuthService().isConnectedFast();
      setState(() {
        _isOffline = !hasInternet;
        _isCheckingWeather = false;
      });
      return;
    }

    if (ConfigManager().hasCachedConfig) {
      ConfigManager().fetchIfNeeded();
      final hasInternet = await SupabaseAuthService().isConnectedFast();
      setState(() {
        _isOffline = !hasInternet;
        _isCheckingWeather = false;
      });
      _lastConfigFetch = DateTime.now();
      return;
    }

    setState(() {
      _isCheckingWeather = true;
      _isOffline = false;
    });

    final hasInternet = await SupabaseAuthService().isConnectedFast();
    if (!hasInternet) {
      setState(() {
        _isOffline = true;
        _isCheckingWeather = false;
      });
      return;
    }

    await ConfigManager().fetchIfNeeded(force: true);
    _lastConfigFetch = DateTime.now();
    setState(() {
      _isCheckingWeather = false;
      _isOffline = false;
    });
  }

  // ─── Permission ────────────────────────────────────────────

  Future<void> _checkLocationPermission() async {
    if (_permissionChecked) return;
    _permissionChecked = true;

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _permissionGranted = true;
      _fetchWeatherIfReady();
    } else if (permission == LocationPermission.deniedForever) {
      _permissionPermanentlyDenied = true;
      _permissionGranted = false;
      setState(() {});
    } else {
      _permissionGranted = false;
      setState(() {});
    }
  }

  void _fetchWeatherIfReady() {
    if (!_permissionGranted) return;
    final cubit = HomeCubit.get(context);
    if (cubit.weatherData == null) {
      cubit.getWeatherData();
    }
  }

  // ─── Location request ─────────────────────────────────────

  Future<void> _requestLocationWithExplanation(BuildContext context) async {
    final cubit = context.read<HomeCubit>();

    await ConfigManager().fetchIfNeeded();
    _lastConfigFetch = DateTime.now();

    if (!AppConfig.isWeatherEnabled) {
      _showWeatherUnavailableDialog(context);
      return;
    }

    if (cubit.weatherData != null) {
      navigateTo(context, WeatherDetailsScreen(weatherData: cubit.weatherData!));
      return;
    }

    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _permissionGranted = true;
      _permissionPermanentlyDenied = false;
      cubit.getWeatherData();
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      _permissionPermanentlyDenied = true;
      _permissionGranted = false;
      _showSettingsDialog(context);
      return;
    }

    final shouldAsk = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.location_on_rounded, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(S.of(ctx).weather_permission_title),
          ],
        ),
        content: Text(S.of(ctx).weather_permission_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(S.of(ctx).notNow),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(S.of(ctx).allow_access),
          ),
        ],
      ),
    );

    if (shouldAsk == true) {
      final newPermission = await Geolocator.requestPermission();
      if (newPermission == LocationPermission.always ||
          newPermission == LocationPermission.whileInUse) {
        _permissionGranted = true;
        _permissionPermanentlyDenied = false;
        cubit.getWeatherData();
      } else if (newPermission == LocationPermission.deniedForever) {
        _permissionPermanentlyDenied = true;
        _permissionGranted = false;
        _showSettingsDialog(context);
      }
    }
  }

  void _showWeatherUnavailableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(ctx).weather_unavailable_title),
        content: Text(S.of(ctx).weather_unavailable_subtitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(ctx).ok),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(ctx).permission_required),
        content: Text(S.of(ctx).location_permission_denied_forever),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(ctx).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Geolocator.openAppSettings();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(S.of(ctx).open_settings),
          ),
        ],
      ),
    );
  }

  Future<void> _showOfflineChatDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(S.of(ctx).chatOfflineTitle),
          ],
        ),
        content: Text(S.of(ctx).chatOfflineMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(ctx).ok),
          ),
        ],
      ),
    );
  }

  void _showChatUnavailableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(ctx).chat_unavailable_title),
        content: Text(S.of(ctx).chat_unavailable_subtitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(ctx).ok),
          ),
        ],
      ),
    );
  }

  // ─── Refresh weather – no banner, just state update ─────

  Future<void> _refreshWeather() async {
    final hasInternet = await SupabaseAuthService().isConnectedFast();
    if (!hasInternet) {
      // ✅ No SnackBar – just update the offline flag.
      // The UI will show the "No Internet" card automatically.
      setState(() => _isOffline = true);
      return;
    }

    // Online: reset offline flag, refresh config and weather
    _lastConfigFetch = null;
    await ConfigManager().fetchIfNeeded(force: true);
    _lastConfigFetch = DateTime.now();

    if (!AppConfig.isWeatherEnabled) {
      _showWeatherUnavailableDialog(context);
      return;
    }

    final cubit = HomeCubit.get(context);
    await cubit.refreshWeather();
    setState(() => _isOffline = false);
  }

  // ─── Chat button callback ──────────────────────────────────

  Future<void> _onChatButtonTap() async {
    final authService = SupabaseAuthService();
    final hasInternet = await authService.isConnectedFast();
    if (!hasInternet) {
      await _showOfflineChatDialog(context);
      return;
    }

    await ConfigManager().fetchIfNeeded();
    _lastConfigFetch = DateTime.now();

    if (!AppConfig.isChatEnabled) {
      _showChatUnavailableDialog(context);
      return;
    }

    navigateTo(context, const AIChatScreen());
  }

  // ─── Loading shimmer ──────────────────────────────────────

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
        ),
      ),
    );
  }

  // ─── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is WeatherLoadedState) {
          final cubit = context.read<HomeCubit>();
          cubit.generateInsights(context);
        }
        if (state is InsightsUpdatedState) {}
      },
      child: BlocBuilder<HomeCubit, HomeStates>(
        buildWhen: (previous, current) =>
        current is HomeGetPlantsSuccessState ||
            current is HomeGetPlantsErrorState ||
            current is HomeLoadingPlantsState ||
            current is WeatherLoadedState ||
            current is WeatherLoadingState ||
            current is LocationPermissionDeniedState ||
            current is LocationPermanentlyDeniedState ||
            current is LocationServicesDisabledState ||
            current is HomeChangeSelectedIndexState ||
            current is InsightsUpdatedState,
        builder: (context, state) {
          final cubit = HomeCubit.get(context);
          final plants = cubit.plants;
          final hasPlants = plants.isNotEmpty;

          if (state is HomeGetPlantsErrorState && plants.isEmpty) {
            return Scaffold(
              body: SafeArea(
                bottom: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: AppColors.error),
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
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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
            extendBody: true,
            body: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                onRefresh: _refreshWeather,
                color: AppColors.primary,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSurface
                    : Colors.white,
                edgeOffset: 120,
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      pinned: true,
                      toolbarHeight: 80,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            S.of(context).home,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: ResponsiveText.headline(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _WeatherCard(
                          isCheckingWeather: _isCheckingWeather,
                          isOffline: _isOffline,
                          permissionGranted: _permissionGranted,
                          permissionPermanentlyDenied: _permissionPermanentlyDenied,
                          onRefresh: _refreshWeather,
                          onLocationRequest: _requestLocationWithExplanation,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: _WeatherDescriptionWidget(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: _ChatButton(onTap: _onChatButtonTap),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Text(
                          S.of(context).choosePlant,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: ResponsiveText.title(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: _PlantCarouselWidget(),
                      ),
                    ),
                    if (hasPlants) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _PlantDetailCardWidget(plant: plants[cubit.selectedIndex]),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _PlantDetailsExpandable(plant: plants[cubit.selectedIndex]),
                        ),
                      ),
                    ] else
                      SliverToBoxAdapter(
                        child: _buildLoadingShimmer(),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    SliverToBoxAdapter(
                      child: SizedBox(height: 120),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Weather Card Widget (unchanged)
// ─────────────────────────────────────────────────────────────

class _WeatherCard extends StatelessWidget {
  final bool isCheckingWeather;
  final bool isOffline;
  final bool permissionGranted;
  final bool permissionPermanentlyDenied;
  final VoidCallback onRefresh;
  final Function(BuildContext) onLocationRequest;

  const _WeatherCard({
    required this.isCheckingWeather,
    required this.isOffline,
    required this.permissionGranted,
    required this.permissionPermanentlyDenied,
    required this.onRefresh,
    required this.onLocationRequest,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeStates, _WeatherCardState>(
      selector: (state) {
        final cubit = HomeCubit.get(context);
        return _WeatherCardState(
          weatherData: cubit.weatherData,
          insights: cubit.insights,
          isLoading: state is WeatherLoadingState,
          error: state is WeatherFetchErrorState ? state.msg : null,
          isLocationServicesDisabled: state is LocationServicesDisabledState,
        );
      },
      builder: (context, cardState) {
        if (isCheckingWeather) {
          return _buildWeatherLoadingCard(context);
        }

        if (!ConfigManager().hasCachedConfig) {
          return _buildWeatherConnectivityRequired(context);
        }

        if (!AppConfig.isWeatherEnabled) {
          return _buildWeatherDisabledCard(context);
        }

        if (cardState.weatherData != null) {
          final scale = ResponsiveText.getScale(context);
          final minHeight = (140 * scale).clamp(120.0, 180.0);

          return GestureDetector(
            onTap: () => onLocationRequest(context),
            child: Container(
              constraints: BoxConstraints(minHeight: minHeight),
              padding: EdgeInsets.all(ResponsiveText.padding(context, 16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: _getWeatherGradient(cardState.weatherData),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: _buildWeatherContent(context, cardState),
            ),
          );
        }

        if (isOffline) {
          return _buildWeatherConnectivityRequired(context);
        }

        final scale = ResponsiveText.getScale(context);
        final minHeight = (140 * scale).clamp(120.0, 180.0);

        return GestureDetector(
          onTap: () => onLocationRequest(context),
          child: Container(
            constraints: BoxConstraints(minHeight: minHeight),
            padding: EdgeInsets.all(ResponsiveText.padding(context, 16)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: _getWeatherGradient(cardState.weatherData),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: _buildWeatherContent(context, cardState),
          ),
        );
      },
    );
  }

  Widget _buildWeatherContent(BuildContext context, _WeatherCardState state) {
    if (state.weatherData != null) {
      return _buildWeatherData(context, state);
    }
    if (state.isLoading) return _buildLoading(context);

    if (permissionPermanentlyDenied) {
      return _buildWeatherError(
        context,
        icon: Icons.location_off,
        message: S.of(context).location_permission_denied_forever,
        buttonText: S.of(context).open_settings,
        onPressed: () => Geolocator.openAppSettings(),
      );
    }

    if (!permissionGranted) {
      return _buildWeatherError(
        context,
        icon: Icons.location_off,
        message: S.of(context).locationDenied,
        buttonText: S.of(context).allowAccess,
        onPressed: () => onLocationRequest(context),
      );
    }

    if (state.isLocationServicesDisabled) {
      return _buildWeatherError(
        context,
        icon: Icons.location_disabled,
        message: S.of(context).gpsDisabled,
        buttonText: S.of(context).enableGPS,
        onPressed: () => HomeCubit.get(context).openLocationSettings(),
      );
    }

    if (state.error != null) {
      return _buildWeatherError(
        context,
        icon: Icons.error_outline,
        message: state.error!,
        buttonText: S.of(context).tryAgain,
        onPressed: () => HomeCubit.get(context).getWeatherData(),
      );
    }

    return _buildWeatherError(
      context,
      icon: Icons.touch_app,
      message: S.of(context).tapToGetWeather,
      buttonText: S.of(context).getWeather,
      onPressed: () => onLocationRequest(context),
    );
  }

  // ── UI helpers ─────────────────────────────────────────────

  Widget _buildWeatherLoadingCard(BuildContext context) {
    final scale = ResponsiveText.getScale(context);
    return Container(
      constraints: BoxConstraints(minHeight: (140 * scale).clamp(120.0, 180.0)),
      padding: EdgeInsets.all(ResponsiveText.padding(context, 16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[300],
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildWeatherConnectivityRequired(BuildContext context) {
    final s = S.of(context);
    final scale = ResponsiveText.getScale(context);
    return Container(
      constraints: BoxConstraints(minHeight: (140 * scale).clamp(120.0, 180.0)),
      padding: EdgeInsets.all(ResponsiveText.padding(context, 16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.grey[400]!, Colors.grey[600]!],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.white70, size: 40),
          const SizedBox(height: 8),
          Text(
            s.noInternet,
            style: TextStyle(color: Colors.white, fontSize: ResponsiveText.body(context)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            s.checkNetwork,
            style: TextStyle(color: Colors.white70, fontSize: ResponsiveText.labelSmall(context)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRefresh,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              s.retry,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDisabledCard(BuildContext context) {
    final s = S.of(context);
    final scale = ResponsiveText.getScale(context);
    return Container(
      constraints: BoxConstraints(minHeight: (140 * scale).clamp(120.0, 180.0)),
      padding: EdgeInsets.all(ResponsiveText.padding(context, 16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.grey[400]!, Colors.grey[600]!],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_rounded, color: Colors.white70, size: 40),
          const SizedBox(height: 8),
          Text(
            s.weather_unavailable_title,
            style: TextStyle(color: Colors.white, fontSize: ResponsiveText.body(context)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            s.weather_unavailable_subtitle,
            style: TextStyle(color: Colors.white70, fontSize: ResponsiveText.labelSmall(context)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherData(BuildContext context, _WeatherCardState state) {
    final weather = state.weatherData!;
    final insights = state.insights;
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
              border: Border.all(color: statusColor.withValues(alpha: 0.4), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
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
          style: TextStyle(color: Colors.white, fontSize: ResponsiveText.body(context)),
        ),
        SizedBox(height: ResponsiveText.padding(context, 12)),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildLoading(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        SizedBox(height: ResponsiveText.padding(context, 12)),
        Text(
          S.of(context).fetchingWeather,
          style: TextStyle(color: Colors.white, fontSize: ResponsiveText.bodySmall(context)),
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

// ─────────────────────────────────────────────────────────────
//  Weather Description Widget
// ─────────────────────────────────────────────────────────────

class _WeatherDescriptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeStates, List<FarmingInsight>>(
      selector: (state) {
        return HomeCubit.get(context).insights;
      },
      builder: (context, insights) {
        if (insights.isEmpty) return const SizedBox.shrink();
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final topInsight = insights.first;
        final Color levelColor = topInsight.level == InsightLevel.critical
            ? AppColors.error
            : (topInsight.level == InsightLevel.warning ? AppColors.warning : AppColors.success);
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
              Icon(topInsight.icon, color: levelColor, size: ResponsiveText.iconSizeSmall(context)),
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
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Chat Button Widget
// ─────────────────────────────────────────────────────────────

class _ChatButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ChatButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Text('👨‍🌾', style: TextStyle(fontSize: 30)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).askAIAssistant,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      S.of(context).askAIAssistantSubtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Plant Carousel Widget
// ─────────────────────────────────────────────────────────────

class _PlantCarouselWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeStates, List<Plant>>(
      selector: (state) {
        return HomeCubit.get(context).plants;
      },
      builder: (context, plants) {
        if (plants.isEmpty) return const SizedBox.shrink();
        final cubit = HomeCubit.get(context);
        final emojiSize = ResponsiveText.emojiSmall(context);
        final carouselHeight = (emojiSize + 32).clamp(110.0, 160.0);
        final padding = ResponsiveText.padding(context, 12);
        final edgeInset = ResponsiveText.padding(context, 4);

        return SizedBox(
          height: carouselHeight,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: edgeInset),
            itemBuilder: (context, index) {
              final plant = plants[index];
              final isSelected = index == cubit.selectedIndex;
              return RepaintBoundary(
                child: GestureDetector(
                  onTap: () => cubit.changeSelectedIndex(index),
                  child: AnimatedScale(
                    scale: isSelected ? 1.08 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: _buildEmojiCard(context, plant, isSelected, emojiSize),
                  ),
                ),
              );
            },
            itemCount: plants.length,
            separatorBuilder: (context, index) => SizedBox(width: padding),
            physics: const BouncingScrollPhysics(),
          ),
        );
      },
    );
  }

  // ── Helper – now accepts `BuildContext context` ──

  Widget _buildEmojiCard(BuildContext context, Plant plant, bool isSelected, double emojiSize) {
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
            color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              plant.emoji,
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
}

// ─────────────────────────────────────────────────────────────
//  Plant Detail Card Widget
// ─────────────────────────────────────────────────────────────

class _PlantDetailCardWidget extends StatelessWidget {
  final Plant plant;

  const _PlantDetailCardWidget({required this.plant});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowColorDark : AppColors.shadowColorLight,
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
                        plant.getCategory(locale),
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
                      plant.getName(locale),
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
                width: (70 * ResponsiveText.getScale(context)).clamp(60.0, 80.0),
                height: (70 * ResponsiveText.getScale(context)).clamp(60.0, 80.0),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  plant.emoji,
                  style: TextStyle(fontSize: ResponsiveText.emojiSmall(context)),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveText.padding(context, 16)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.calendar_today, color: AppColors.primary, size: ResponsiveText.iconSizeSmall(context)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${S.of(context).plantingTime}: ${plant.getPlantingTime(locale)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: ResponsiveText.label(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Plant Details Expandable
// ─────────────────────────────────────────────────────────────

class _PlantDetailsExpandable extends StatefulWidget {
  final Plant plant;

  const _PlantDetailsExpandable({required this.plant});

  @override
  _PlantDetailsExpandableState createState() => _PlantDetailsExpandableState();
}

class _PlantDetailsExpandableState extends State<_PlantDetailsExpandable>
    with TickerProviderStateMixin {
  late List<bool> _expandedStates;
  late List<AnimationController?> _controllers;

  @override
  void initState() {
    super.initState();
    _expandedStates = [false, false, false, false];
    _controllers = List.filled(4, null);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  void _toggleExpanded(int index) {
    setState(() {
      _expandedStates[index] = !_expandedStates[index];
      if (_expandedStates[index]) {
        _controllers[index] ??= AnimationController(
          duration: const Duration(milliseconds: 400),
          vsync: this,
        );
        _controllers[index]!.forward();
      } else {
        _controllers[index]?.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;
    final plant = widget.plant;

    final sections = [
      {
        'title': S.of(context).description,
        'icon': Icons.description,
        'color': const Color(0xFF4CAF50),
        'content': plant.getDescription(locale),
      },
      {
        'title': S.of(context).nutrition,
        'icon': Icons.fastfood,
        'color': const Color(0xFFFF9800),
        'content': plant.nutritionRecommendations,
      },
      {
        'title': S.of(context).storage,
        'icon': Icons.storage,
        'color': const Color(0xFF2196F3),
        'content': plant.storageInfo,
      },
      {
        'title': S.of(context).diseases,
        'icon': Icons.health_and_safety,
        'color': const Color(0xFFF44336),
        'content': plant.diseaseAndPestControl,
      },
    ];

    return FadeInAnimation(
      duration: AnimationConstants.normalDuration,
      child: Column(
        children: List.generate(4, (index) {
          final section = sections[index];
          final color = section['color'] as Color;
          final isExpanded = _expandedStates[index];
          final animation = _controllers[index];

          return Padding(
            padding: EdgeInsets.only(bottom: ResponsiveText.padding(context, 12)),
            child: _buildExpandableCard(
              context: context,
              index: index,
              title: section['title'] as String,
              icon: section['icon'] as IconData,
              color: color,
              isDark: isDark,
              isExpanded: isExpanded,
              animation: animation,
              onTap: () => _toggleExpanded(index),
              plant: plant,
              sectionData: section['content'],
              locale: locale,
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
    required AnimationController? animation,
    required VoidCallback onTap,
    required Plant plant,
    required dynamic sectionData,
    required String locale,
  }) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              isDark ? (color).withValues(alpha: 0.08) : (color).withValues(alpha: 0.04),
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
                        child: Icon(icon, color: color, size: 24),
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
              if (isExpanded && animation != null)
                FadeTransition(
                  opacity: animation.drive(
                    Tween<double>(begin: 0.0, end: 1.0),
                  ),
                  child: Container(
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
                      locale: locale,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Content builders ───────────────────────────────────────

  Widget _buildSectionContent({
    required BuildContext context,
    required int index,
    required dynamic sectionData,
    required Color color,
    required bool isDark,
    required String locale,
  }) {
    if (index == 0) {
      return Text(
        sectionData as String,
        style: TextStyle(
          fontSize: ResponsiveText.body(context),
          height: 1.8,
          color: isDark ? Colors.grey[300] : Colors.grey[700],
          fontWeight: FontWeight.w400,
        ),
      );
    } else if (index == 1) {
      final nutrition = sectionData as NutritionRecommendations;
      return Column(
        children: [
          _buildLabeledText(
            context,
            S.of(context).nitrogen,
            nutrition.nitrogen[locale] ?? '',
            color,
            isDark,
          ),
          _buildLabeledText(
            context,
            S.of(context).phosphorus,
            nutrition.phosphorus[locale] ?? '',
            color,
            isDark,
          ),
          _buildLabeledText(
            context,
            S.of(context).potassium,
            nutrition.potassium[locale] ?? '',
            color,
            isDark,
          ),
        ],
      );
    } else if (index == 2) {
      final storage = sectionData as StorageInfo;
      return Column(
        children: [
          _buildLabeledText(
            context,
            S.of(context).temperature,
            storage.temperature[locale] ?? '',
            color,
            isDark,
          ),
          _buildLabeledText(
            context,
            S.of(context).humidity,
            storage.humidity[locale] ?? '',
            color,
            isDark,
          ),
        ],
      );
    } else {
      final diseases = sectionData as List<Disease>;
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
        children: diseases.map((disease) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: ResponsiveText.padding(context, 8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_rounded, size: 16, color: color),
                    SizedBox(width: ResponsiveText.padding(context, 8)),
                    Expanded(
                      child: Text(
                        disease.name[locale] ?? disease.name['en'] ?? '',
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
                  disease.prevention[locale] ?? disease.prevention['en'] ?? '',
                  style: TextStyle(
                    fontSize: ResponsiveText.bodySmall(context),
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                    height: 1.6,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildLabeledText(
      BuildContext context,
      String label,
      String value,
      Color color,
      bool isDark,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveText.padding(context, 8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.only(top: ResponsiveText.padding(context, 6)),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          SizedBox(width: ResponsiveText.padding(context, 10)),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveText.label(context),
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            ),
          ),
          SizedBox(width: ResponsiveText.padding(context, 8)),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveText.labelSmall(context),
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Helper class for Weather Card state
// ─────────────────────────────────────────────────────────────

class _WeatherCardState {
  final WeatherData? weatherData;
  final List<FarmingInsight> insights;
  final bool isLoading;
  final bool isLocationServicesDisabled;
  final String? error;

  _WeatherCardState({
    this.weatherData,
    this.insights = const [],
    this.isLoading = false,
    this.isLocationServicesDisabled = false,
    this.error,
  });
}