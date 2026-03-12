import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:api_http_client/api_http_client.dart';
import 'package:repository/repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required SettingRepository settingRepository})
      : _settingRepository = settingRepository,
        super(const SettingsState());

  final SettingRepository _settingRepository;

  Future<void> fetchSettings() async {
    emit(state.copyWith(status: SettingsStatus.loading));
    final response = await _settingRepository.getSettings();
    await response.when<void>(
      success: (SettingResponse settingResponse) async {
        emit(
          state.copyWith(
            status: SettingsStatus.success,
            settingsData: settingResponse.data,
          ),
        );
      },
      failure: (String error) async {
        emit(
          state.copyWith(
            status: SettingsStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }
}
