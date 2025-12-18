import 'package:api_http_client/api_http_client.dart';

class HospitalDetailResponse extends BaseResponse {
  HospitalDetailResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    details = HospitalDetail.fromJson(json['data']);
  }

  late HospitalDetail details;
}

class HospitalDetail {
  final String id;
  final String? image;
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
  final String latitude;
  final String longitude;
  final String? rating;
  final int? reviewCount;
  final bool isVerified;
  final String status;
  final String type;

  HospitalDetail({
    required this.id,
    this.image,
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
    required this.latitude,
    required this.longitude,
    this.rating,
    this.reviewCount,
    required this.isVerified,
    required this.status,
    required this.type,
  });

  factory HospitalDetail.fromJson(Map<String, dynamic> json) {
    return HospitalDetail(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      country: json['country'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      website: json['website'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'] ?? 0.0,
      rating: json['rating'] != null ? json['rating'].toString() : null,
      reviewCount: json['review_count'],
      isVerified: json['is_verified'] ?? false,
      status: json['status'],
      type: json['type'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
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
      'rating': rating,
      'review_count': reviewCount,
      'is_verified': isVerified,
      'status': status,
      'type': type,
    };
  }
}
