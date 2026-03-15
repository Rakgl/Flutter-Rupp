part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, failure, logoutSuccess }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.name = 'Peter Parker',
    this.email = 'spider.man@gmail.com',
    this.location = 'New York, NY',
    this.phone = '+1234567890',
    this.walletBalance = 1250.50,
    this.completionProgress = 0.5,
    this.isPushEnabled = true,
    this.isDarkMode = false,
  });

  final ProfileStatus status;
  final String name;
  final String email;
  final String location;
  final String phone;
  final double walletBalance;
  final double completionProgress;
  final bool isPushEnabled;
  final bool isDarkMode;

  @override
  List<Object> get props => [
    status,
    name,
    email,
    location,
    phone,
    walletBalance,
    completionProgress,
    isPushEnabled,
    isDarkMode,
  ];

  ProfileState copyWith({
    ProfileStatus? status,
    String? name,
    String? email,
    String? location,
    String? phone,
    bool? isPushEnabled,
    bool? isDarkMode,
  }) {
    return ProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      walletBalance: walletBalance,
      completionProgress: completionProgress,
      isPushEnabled: isPushEnabled ?? this.isPushEnabled,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
