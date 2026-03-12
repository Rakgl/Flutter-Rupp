import 'package:equatable/equatable.dart';

class AppointmentDetailResponse extends Equatable {
  const AppointmentDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  final bool success;
  final String message;
  final dynamic data;

  factory AppointmentDetailResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'],
    );
  }

  @override
  List<Object?> get props => [success, message, data];
}
