class BookAppointmentRequest {
  const BookAppointmentRequest({
    required this.petId,
    required this.serviceId,
    required this.startTime,
    this.specialRequests,
    this.storeId,
  });

  final String petId;
  final String serviceId;
  final String startTime; // Y-m-d H:i:s
  final String? specialRequests;
  final String? storeId;

  Map<String, dynamic> toJson() {
    return {
      'pet_id': petId,
      'service_id': serviceId,
      'start_time': startTime,
      'special_requests': specialRequests,
      if (storeId != null) 'store_id': storeId,
    };
  }

  BookAppointmentRequest copyWith({
    String? petId,
    String? serviceId,
    String? startTime,
    String? specialRequests,
    String? storeId,
  }) {
    return BookAppointmentRequest(
      petId: petId ?? this.petId,
      serviceId: serviceId ?? this.serviceId,
      startTime: startTime ?? this.startTime,
      specialRequests: specialRequests ?? this.specialRequests,
      storeId: storeId ?? this.storeId,
    );
  }
}
