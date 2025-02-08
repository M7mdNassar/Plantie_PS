abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeLoadingPlantsState extends HomeStates {}

class HomeGetPlantsSuccessState extends HomeStates {}

class HomeGetPlantsErrorState extends HomeStates {}

class HomeChangeSelectedIndexState extends HomeStates {}

/// Weather states
class WeatherInitialState extends HomeStates {}

class WeatherLoadingState extends HomeStates {}

class WeatherLoadedState extends HomeStates {}

class LocationPermissionDeniedState extends HomeStates {}

class LocationPermanentlyDeniedState extends HomeStates {}

class LocationServicesDisabledState extends HomeStates {}

class WeatherFetchErrorState extends HomeStates {
  final String msg;

  WeatherFetchErrorState(this.msg);
}
