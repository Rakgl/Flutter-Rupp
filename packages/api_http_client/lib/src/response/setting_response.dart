import 'package:equatable/equatable.dart';

class SettingResponse extends Equatable {
  const SettingResponse({
    required this.success,
    required this.message,
    this.data,
  });

  final bool success;
  final String message;
  final SettingData? data;

  factory SettingResponse.fromJson(Map<String, dynamic> json) {
    return SettingResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? SettingData.fromJson(json['data']) : null,
    );
  }

  @override
  List<Object?> get props => [success, message, data];
}

class SettingData extends Equatable {
  const SettingData({
    this.appName,
    this.color,
    this.logo,
    this.aboutUs,
  });

  final String? appName;
  final String? color;
  final String? logo;
  final AboutUs? aboutUs;

  factory SettingData.fromJson(Map<String, dynamic> json) {
    return SettingData(
      appName: json['app_name'] as String?,
      color: json['color'] as String?,
      logo: json['logo'] as String?,
      aboutUs: json['about_us'] != null ? AboutUs.fromJson(json['about_us']) : null,
    );
  }

  @override
  List<Object?> get props => [appName, color, logo, aboutUs];
}

class AboutUs extends Equatable {
  const AboutUs({
    this.description,
    this.location,
    this.footerNote,
  });

  final String? description;
  final LocationData? location;
  final String? footerNote;

  factory AboutUs.fromJson(Map<String, dynamic> json) {
    return AboutUs(
      description: json['description'] as String?,
      location: json['location'] != null ? LocationData.fromJson(json['location']) : null,
      footerNote: json['footer_note'] as String?,
    );
  }

  @override
  List<Object?> get props => [description, location, footerNote];
}

class LocationData extends Equatable {
  const LocationData({
    this.latitude,
    this.longitude,
  });

  final String? latitude;
  final String? longitude;

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude];
}
