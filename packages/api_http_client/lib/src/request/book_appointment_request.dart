class BookAppointmentRequest {
  const BookAppointmentRequest({
    required this.slotId,
    required this.reasonForVisit,
    // this.patientNotes,
    required this.appointmentType,
    required this.serviceId,
  });

  final String slotId;
  final String reasonForVisit;
  // final String? patientNotes;
  final String appointmentType;
  final String serviceId;

  // copy with
  BookAppointmentRequest copyWith({
    String? slotId,
    String? hospitalId,
    String? reasonForVisit,
    String? patientNotes,
    String? appointmentType,
    String? serviceId,
  }) {
    return BookAppointmentRequest(
      slotId: slotId ?? this.slotId,
      reasonForVisit: reasonForVisit ?? this.reasonForVisit,
      // patientNotes: patientNotes ?? this.patientNotes,
      appointmentType: appointmentType ?? this.appointmentType,
      serviceId: serviceId ?? this.serviceId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slot_id': slotId,
      'reason_for_visit': reasonForVisit,
      // 'patient_notes': patientNotes,
      'appointment_type': appointmentType,
      'service_id': serviceId,
    };
  }
}
