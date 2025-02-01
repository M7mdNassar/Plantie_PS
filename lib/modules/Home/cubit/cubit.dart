import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/modules/Home/cubit/states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);
}
