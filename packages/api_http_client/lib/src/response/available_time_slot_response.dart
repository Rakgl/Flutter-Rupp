import 'package:api_http_client/api_http_client.dart';
import 'package:equatable/equatable.dart';

class AvailableTimeSlotResponse extends BaseResponse {
  AvailableTimeSlotResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    final data = json.getMapOrDefault('data');
    morning = (data.getListOrDefault('morning') as List)
        .map((e) => AvailableTimeSlot.fromJson(e))
        .toList();
    afternoon = (data.getListOrDefault('afternoon') as List)
        .map((e) => AvailableTimeSlot.fromJson(e))
        .toList();
    evening = (data.getListOrDefault('evening') as List)
        .map((e) => AvailableTimeSlot.fromJson(e))
        .toList();
  }
  late List<AvailableTimeSlot> morning;
  late List<AvailableTimeSlot> afternoon;
  late List<AvailableTimeSlot> evening;
}

class AvailableTimeSlot extends Equatable {
  const AvailableTimeSlot({
    required this.id,
    required this.doctorId,
    required this.hospitalId,
    required this.slotDate,
    required this.startTime,
    required this.endTime,
    required this.slotDurationMinutes,
    required this.isBooked,
    this.bookedByAppointmentId,
    required this.status,
  });

  final String id;
  final String doctorId;
  final String hospitalId;
  final DateTime slotDate;
  final String startTime;
  final String endTime;
  final int slotDurationMinutes;
  final bool isBooked;
  final String? bookedByAppointmentId;
  final String status;

  factory AvailableTimeSlot.fromJson(Map<String, dynamic> json) {
    return AvailableTimeSlot(
      id: json.getStringOrDefault('id'),
      doctorId: json.getStringOrDefault('doctor_id'),
      hospitalId: json.getStringOrDefault('hospital_id'),
      slotDate: DateTime.parse(json.getStringOrDefault('slot_date')),
      startTime: json.getStringOrDefault('start_time'),
      endTime: json.getStringOrDefault('end_time'),
      slotDurationMinutes: json.getIntOrDefault('slot_duration_minutes'),
      isBooked: json.getBoolOrDefault('is_booked'),
      bookedByAppointmentId:
          json.getStringOrDefault('booked_by_appointment_id'),
      status: json.getStringOrDefault('active'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'hospital_id': hospitalId,
      'slot_date': slotDate.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'slot_duration_minutes': slotDurationMinutes,
      'is_booked': isBooked,
      'booked_by_appointment_id': bookedByAppointmentId,
      'status': status,
    };
  }

  AvailableTimeSlot copyWith({
    String? id,
    String? doctorId,
    String? hospitalId,
    DateTime? slotDate,
    String? startTime,
    String? endTime,
    int? slotDurationMinutes,
    bool? isBooked,
    String? bookedByAppointmentId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? status,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
  }) {
    return AvailableTimeSlot(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      hospitalId: hospitalId ?? this.hospitalId,
      slotDate: slotDate ?? this.slotDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      slotDurationMinutes: slotDurationMinutes ?? this.slotDurationMinutes,
      isBooked: isBooked ?? this.isBooked,
      bookedByAppointmentId:
          bookedByAppointmentId ?? this.bookedByAppointmentId,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        doctorId,
        hospitalId,
        slotDate,
        startTime,
        endTime,
        slotDurationMinutes,
        isBooked,
        bookedByAppointmentId,
        status,
      ];
}
