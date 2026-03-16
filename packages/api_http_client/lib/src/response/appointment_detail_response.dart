import 'package:api_http_client/api_http_client.dart';
import 'package:equatable/equatable.dart';

class AppointmentDetailResponse extends Equatable {
  const AppointmentDetailResponse({
    required this.success,
    required this.message,
    this.appointment,
  });

  final bool success;
  final String message;
  final AppointmentModel? appointment;

  factory AppointmentDetailResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      appointment: json['data'] != null
          ? AppointmentModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [success, message, appointment];
}
