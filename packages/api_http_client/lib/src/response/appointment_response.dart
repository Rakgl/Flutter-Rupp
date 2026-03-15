
import 'package:api_http_client/api_http_client.dart';

class AppointmentResponse extends BaseResponse {
  AppointmentResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    final data = json.getListOrDefault('data');
    appointments = data.map((e) => AppointmentModel.fromJson(e)).toList();
  }

  late List<AppointmentModel> appointments;
}

class AppointmentModel {
  final String id;
  final String status;
  final DateTime startTime;
  final DateTime endTime;
  final AppointmentPet pet;
  final AppointmentService service;

  AppointmentModel({
    required this.id,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.pet,
    required this.service,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json.getStringOrDefault('id'),
      status: json.getStringOrDefault('status'),
      startTime: DateTime.parse(json.getStringOrDefault('start_time')),
      endTime: DateTime.parse(json.getStringOrDefault('end_time')),
      pet: AppointmentPet.fromJson(json.getMapOrDefault('pet')),
      service: AppointmentService.fromJson(json.getMapOrDefault('service')),
    );
  }
}

class AppointmentPet {
  final String id;
  final String name;
  final String? imageUrl;

  AppointmentPet({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory AppointmentPet.fromJson(Map<String, dynamic> json) {
    return AppointmentPet(
      id: json.getStringOrDefault('id'),
      name: json.getStringOrDefault('name'),
      imageUrl: json.getStringOrNull('image_url'),
    );
  }
}

class AppointmentService {
  final String id;
  final String name;
  final String price;

  AppointmentService({
    required this.id,
    required this.name,
    required this.price,
  });

  factory AppointmentService.fromJson(Map<String, dynamic> json) {
    return AppointmentService(
      id: json.getStringOrDefault('id'),
      name: json.getStringOrDefault('name'),
      price: json['price']?.toString() ?? '0.00',
    );
  }
}
