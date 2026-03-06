import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'accessory_state.dart';

class AccessoryCubit extends Cubit<AccessoryState> {
  AccessoryCubit() : super(const AccessoryState());
}
