import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coco_dataset/utils/app/app_logger.dart';

abstract class BaseCubit<S> extends Cubit<S> {
  BaseCubit(super.initialState);

  void safeEmit(S state) {
    if (!isClosed) {
      emit(state);
    } else {
      AppLogger.e(
        'Emitter is closed, cannot emit state: $state',
        error: 'Emitter is closed',
        stackTrace: StackTrace.current,
      );
    }
  }
}
