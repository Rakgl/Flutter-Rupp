import 'dart:io';

import 'package:api_http_client/api_http_client.dart';

class ConfirmAppointmentRequest {
  final HospitalDetail hospital;
  final DoctorDetailModel doctor;
  final String? date;
  final AvailableTimeSlot? timeSlot;
  final File? insurance;
  final String? reason;
  final int? appointmentType;
  final ServiceModel? service;

  const ConfirmAppointmentRequest({
    required this.hospital,
    required this.doctor,
    this.date,
    this.timeSlot,
    this.insurance,
    this.reason,
    this.appointmentType,
    this.service,
  });

  // to json
  Map<String, dynamic> toJson() {
    return {
      'hospital': hospital.toJson(),
      'doctor': doctor.toJson(),
      'date': date,
      'time_slot': timeSlot,
      'insurance': insurance?.path,
      'reason': reason,
      'appointment_type': appointmentType,
      'service': service?.toJson(),
    };
  }

  // copy with
  ConfirmAppointmentRequest copyWith({
    HospitalDetail? hospital,
    DoctorDetailModel? doctor,
    String? date,
    AvailableTimeSlot? timeSlot,
    File? insurance,
    String? reason,
    int? appointmentType,
    ServiceModel? service,
  }) {
    return ConfirmAppointmentRequest(
      hospital: hospital ?? this.hospital,
      doctor: doctor ?? this.doctor,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      insurance: insurance ?? this.insurance,
      reason: reason ?? this.reason,
      appointmentType: appointmentType ?? this.appointmentType,
      service: service ?? this.service,
    );
  }
}
