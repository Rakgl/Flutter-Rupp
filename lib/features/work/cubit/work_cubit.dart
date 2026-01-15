import 'package:bloc/bloc.dart';

part 'work_state.dart';

class WorkCubit extends Cubit<WorkState> {
  WorkCubit() : super(const WorkState());
}
