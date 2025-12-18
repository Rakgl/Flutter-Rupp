import 'package:api_http_client/api_http_client.dart';

class PharmacyDetailResponse extends BaseResponse {
  PharmacyDetailResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    final data = json.getMapOrDefault('data');
    pharmacyDetail = PharmacyDetail.fromJson(data);
  }

  late PharmacyDetail pharmacyDetail;
}

class PharmacyDetail {
  final String id;
  final String name;
  final String? logoUrl;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final double? latitude;
  final double? longitude;
  final String phoneNumber;
  final String email;
  final String licenseNumber;
  final String openingTime;
  final String closingTime;
  final bool is24Hours;
  final bool deliversMedication;
  final String deliveryDetails;
  final double averageRating;
  final int reviewCount;
  final bool isVerified;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  PharmacyDetail({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.latitude,
    this.longitude,
    required this.phoneNumber,
    required this.email,
    required this.licenseNumber,
    required this.openingTime,
    required this.closingTime,
    required this.is24Hours,
    required this.deliversMedication,
    required this.deliveryDetails,
    required this.averageRating,
    required this.reviewCount,
    required this.isVerified,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PharmacyDetail.fromJson(Map<String, dynamic> json) {
    return PharmacyDetail(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logo_url'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      country: json['country'],
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      phoneNumber: json['phone_number'],
      email: json['email'],
      licenseNumber: json['license_number'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      is24Hours: json['is_24_hours'],
      deliversMedication: json['delivers_medication'],
      deliveryDetails: json['delivery_details'],
      averageRating: double.tryParse(json['average_rating'].toString()) ?? 0.0,
      reviewCount: json['review_count'],
      isVerified: json['is_verified'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_url': logoUrl,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'phone_number': phoneNumber,
      'email': email,
      'license_number': licenseNumber,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'is_24_hours': is24Hours,
      'delivers_medication': deliversMedication,
      'delivery_details': deliveryDetails,
      'average_rating': averageRating.toString(),
      'review_count': reviewCount,
      'is_verified': isVerified,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
