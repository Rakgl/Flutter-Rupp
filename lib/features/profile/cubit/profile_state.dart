part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, updateSuccess, failure, logoutSuccess }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.name,
    this.email,
    this.deliveryAddress,
    this.phone,
    this.image,
    this.pickedImage,
    this.isPushEnabled = true,
    this.isDarkMode = false,
    this.errorMessage,
  });

  final ProfileStatus status;
  final String? name;
  final String? email;
  final String? deliveryAddress;
  final String? phone;
  final String? image;
  final File? pickedImage;
  final bool isPushEnabled;
  final bool isDarkMode;
  final String? errorMessage;

  @override
  List<Object?> get props => [
    status,
    name,
    email,
    deliveryAddress,
    phone,
    image,
    pickedImage,
    isPushEnabled,
    isDarkMode,
    errorMessage,
  ];

  ProfileState copyWith({
    ProfileStatus? status,
    String? name,
    String? email,
    String? deliveryAddress,
    String? phone,
    String? image,
    File? pickedImage,
    bool? isPushEnabled,
    bool? isDarkMode,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      pickedImage: pickedImage ?? this.pickedImage,
      isPushEnabled: isPushEnabled ?? this.isPushEnabled,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
