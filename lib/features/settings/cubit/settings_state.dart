part of 'settings_cubit.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.settingsData,
    this.errorMessage,
  });

  final SettingsStatus status;
  final SettingData? settingsData;
  final String? errorMessage;

  SettingsState copyWith({
    SettingsStatus? status,
    SettingData? settingsData,
    String? errorMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settingsData: settingsData ?? this.settingsData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, settingsData, errorMessage];
}
