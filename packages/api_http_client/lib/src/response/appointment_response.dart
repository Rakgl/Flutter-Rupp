
import 'package:api_http_client/api_http_client.dart';

class AppointmentResponse extends BaseResponse {
  AppointmentResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    final data = json.getListOrDefault('data');
    appointments = data.map((e) => AppointmentModel.fromJson(e)).toList();

    isReachMax = json.getBoolOrDefault('reach_max');
  }

  late List<AppointmentModel> appointments;
  late bool isReachMax;
}

class AppointmentModel {
  final String id;
  final String patientId;
  final String doctorId;
  final String hospitalId;
  final String? serviceId;
  final String doctorAvailabilitySlotId;
  final DateTime appointmentDateTime;
  final int durationMinutes;
  final String status;
  final String reasonForVisit;
  final String? doctorNotes;
  final String patientNotes;
  final String meetingLink;
  final String? cancellationReason;
  final String? cancelledBy;
  final String consultationFeeCharged;
  final String paymentStatus;
  final String? paymentGatewayTransactionId;
  final String appointmentType;
  final bool alertMe15mn;
  final bool reminderSent;
  final String dailyRoomName;
  final DoctorModel doctor;
  final HospitalAppointment hospital;
  final ServiceModel? service;

  AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.hospitalId,
    this.serviceId,
    required this.doctorAvailabilitySlotId,
    required this.appointmentDateTime,
    required this.durationMinutes,
    required this.status,
    required this.reasonForVisit,
    this.doctorNotes,
    required this.patientNotes,
    required this.meetingLink,
    this.cancellationReason,
    this.cancelledBy,
    required this.consultationFeeCharged,
    required this.paymentStatus,
    this.paymentGatewayTransactionId,
    required this.appointmentType,
    required this.alertMe15mn,
    required this.reminderSent,
    required this.dailyRoomName,
    required this.doctor,
    required this.hospital,
    this.service,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json.getStringOrDefault('id'),
      patientId: json.getStringOrDefault('patient_id'),
      doctorId: json.getStringOrDefault('doctor_id'),
      hospitalId: json.getStringOrDefault('hospital_id'),
      serviceId: json.getStringOrNull('service_id'),
      doctorAvailabilitySlotId:
          json.getStringOrDefault('doctor_availability_slot_id'),
      appointmentDateTime: DateTime.parse(
        json.getStringOrDefault('appointment_datetime'),
      ),
      durationMinutes: json.getIntOrDefault('duration_minutes'),
      status: json.getStringOrDefault('status'),
      reasonForVisit: json.getStringOrDefault('reason_for_visit'),
      doctorNotes: json.getStringOrNull('doctor_notes'),
      patientNotes: json.getStringOrDefault('patient_notes'),
      meetingLink: json.getStringOrDefault('meeting_link'),
      cancellationReason: json.getStringOrNull('cancellation_reason'),
      cancelledBy: json.getStringOrNull('cancelled_by'),
      consultationFeeCharged:
          json.getStringOrDefault('consultation_fee_charged'),
      paymentStatus: json.getStringOrDefault('payment_status'),
      paymentGatewayTransactionId:
          json.getStringOrNull('payment_gateway_transaction_id'),
      appointmentType: json.getStringOrDefault('appointment_type'),
      alertMe15mn: json.getBoolOrDefault('alert_me_15mn'),
      reminderSent: json.getBoolOrDefault('reminder_sent'),
      dailyRoomName: json.getStringOrDefault('daily_room_name'),
      doctor: DoctorModel.fromJson(json.getMapOrDefault('doctor')),
      hospital: HospitalAppointment.fromJson(json.getMapOrDefault('hospital')),
      service:  json.getMapOrNull('service') != null
          ? ServiceModel.fromJson(json.getMapOrDefault('service'))
          : null,
    );
  }
}

class HospitalAppointment {
  final String id;
  final String name;

  const HospitalAppointment({
    required this.id,
    required this.name,
  });

  factory HospitalAppointment.fromJson(Map<String, dynamic> json) {
    return HospitalAppointment(
      id: json['id'],
      name: json['name'],
    );
  }
}

class DoctorUser {
  final String id;
  final String name;
  final String? image;

  DoctorUser({
    required this.id,
    required this.name,
    this.image,
  });

  factory DoctorUser.fromJson(Map<String, dynamic> json) {
    return DoctorUser(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class AppointmentHospital {
  final String id;
  final String name;

  AppointmentHospital({
    required this.id,
    required this.name,
  });

  factory AppointmentHospital.fromJson(Map<String, dynamic> json) {
    return AppointmentHospital(
      id: json['id'],
      name: json['name'],
    );
  }
}
