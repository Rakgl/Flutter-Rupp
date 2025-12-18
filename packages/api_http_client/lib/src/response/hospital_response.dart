import 'package:api_http_client/api_http_client.dart';

class HospitalResponse extends BaseResponse {
  HospitalResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getListOrDefault('data');
    hospitals = data.map((e) => Hospital.fromJson(e)).toList();
    isReachMax = json.getBoolOrDefault('reach_max');
  }

  late bool isReachMax;
  late List<Hospital> hospitals;
}

class Hospital {
  final String id;
  final String name;
  final String address;
  final String city;
  final String? state;
  final String zipCode;
  final String country;
  final String phoneNumber;
  final String email;
  final String website;
  final String description;
  final String? latitude;
  final String? longitude;
  final bool isVerified;
  final String? image;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    this.state,
    required this.zipCode,
    required this.country,
    required this.phoneNumber,
    required this.email,
    required this.website,
    required this.description,
    this.latitude,
    this.longitude,
    required this.isVerified,
    this.image,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      country: json['country'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      website: json.getStringOrDefault('website'),
      description: json.getStringOrDefault('description'),
      latitude: json.getStringOrDefault('latitude'),
      longitude: json.getStringOrNull('longitude'),
      isVerified: json.getBoolOrDefault('is_verified'),
      image: json.getStringOrNull('image'),
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'phone_number': phoneNumber,
      'email': email,
      'website': website,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'is_verified': isVerified,
    };
  }
}
