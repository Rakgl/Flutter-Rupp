import 'package:api_http_client/api_http_client.dart';

class PharmacyResponse extends BaseResponse {
  PharmacyResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getListOrDefault('data');
    pharmacies = data.map((e) => Pharmacy.fromJson(e)).toList();

    final meta = json.getMapOrDefault('meta');
    currentPage = meta.getIntOrDefault('current_page');
    lastPage = meta.getIntOrDefault('last_page');
    hasNextPage = currentPage < lastPage;
    hasPreviousPage = currentPage > 1;
  }
  late List<Pharmacy> pharmacies;
  late int currentPage;
  late int lastPage;
  late bool hasNextPage;
  late bool hasPreviousPage;
}

class Pharmacy {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String phoneNumber;
  final String email;
  final String licenseNumber;
  final String openingTime;
  final String closingTime;
  final bool is24Hours;
  final bool deliversMedication;
  final String deliveryDetails;
  final String? logoUrl;

  Pharmacy({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.phoneNumber,
    required this.email,
    required this.licenseNumber,
    required this.openingTime,
    required this.closingTime,
    required this.is24Hours,
    required this.deliversMedication,
    required this.deliveryDetails,
    this.logoUrl,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      country: json['country'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      licenseNumber: json['license_number'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      is24Hours: json['is_24_hours'],
      deliversMedication: json['delivers_medication'],
      deliveryDetails: json['delivery_details'],
      logoUrl: json['logo_url'],
    );
  }

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
      'license_number': licenseNumber,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'is_24_hours': is24Hours,
      'delivers_medication': deliversMedication,
      'delivery_details': deliveryDetails,
      'logo_url': logoUrl,
    };
  }
}
