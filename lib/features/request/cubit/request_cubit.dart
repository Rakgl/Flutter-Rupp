import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'request_state.dart';

class RequestCubit extends Cubit<RequestState> {
  RequestCubit() : super(const RequestState());
}
