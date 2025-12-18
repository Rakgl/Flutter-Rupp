import 'package:api_http_client/api_http_client.dart';

class SpecialityResponse extends BaseResponse {
  SpecialityResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    final data = json.getListOrDefault('data');

    specialities = data.map((e) => Speciality.fromJson(e)).toList();

    isReachMax = json.getBoolOrDefault('reach_max');
  }

  late List<Speciality> specialities;

  late bool isReachMax;
}

class Speciality {
  final String id;
  final String? image;
  final String name;
  final String description;

  const Speciality({
    required this.id,
    this.image,
    required this.name,
    required this.description,
  });

  // factory
  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      id: json.getStringOrDefault('id'),
      image: json.getStringOrDefault('image'),
      name: json.getStringOrDefault('name'),
      description: json.getStringOrDefault('description'),
    );
  }
}
