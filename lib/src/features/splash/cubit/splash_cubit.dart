import 'package:decora/src/features/splash/cubit/splash_sate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void animationCompleted() {
    emit(SplashCompleted());
  }
}
