import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/modules/Detection/cubit/states.dart';

class DetectionCubit extends Cubit<DetectionStates> {
  DetectionCubit() : super(DetectionInitialState());

  static DetectionCubit get(context) => BlocProvider.of(context);
}
