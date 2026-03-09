import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'card_state.dart';

class CardCubit extends Cubit<CardState> {
  CardCubit() : super(const CardState());
}
