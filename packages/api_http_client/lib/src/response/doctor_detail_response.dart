import 'package:api_http_client/api_http_client.dart';

class DoctorDetailResponse extends BaseResponse {
  DoctorDetailResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    final data = json.getMapOrDefault('data');
    doctorDetail = DoctorDetailModel.fromJson(data);
  }

  late DoctorDetailModel doctorDetail;
}

class DoctorDetailModel {
  final String id;
  final String userId;
  final String title;
  final String registrationNumber;
  final String bio;
  final String gender;
  final DateTime dateOfBirth;
  final String consultationFee;
  final String currencyCode;
  final int yearsOfExperience;
  final List<String> qualifications;
  final String? profilePicturePath;
  final bool isVerified;
  final bool isAvailableForConsultation;
  final String availabilityStatus;
  final String? averageRating;
  final String status;
  final User user;
  final List<DoctorSpeciality> specialities;
  final List<HospitalDetail> hospitals;

  DoctorDetailModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.registrationNumber,
    required this.bio,
    required this.gender,
    required this.dateOfBirth,
    required this.consultationFee,
    required this.currencyCode,
    required this.yearsOfExperience,
    required this.qualifications,
    required this.profilePicturePath,
    required this.isVerified,
    required this.isAvailableForConsultation,
    required this.availabilityStatus,
    this.averageRating,
    required this.status,
    required this.user,
    required this.specialities,
    required this.hospitals,
  });

  factory DoctorDetailModel.fromJson(Map<String, dynamic> json) {
    final qualificationsData = json['qualifications'];
    List<String> qualificationsList;
    if (qualificationsData is String) {
      // This logic is brittle and assumes a very specific string format like "[\"item1\",\"item2\"]"
      qualificationsList = qualificationsData
          .replaceAll(RegExp(r'^\[|\]$'), '')
          .split('","')
          .map((e) => e.replaceAll('"', ''))
          .toList();
    } else if (qualificationsData is List) {
      qualificationsList = List<String>.from(qualificationsData);
    } else {
      qualificationsList = [];
    }

    return DoctorDetailModel(
      id: json.getStringOrDefault('id'),
      userId: json.getStringOrDefault('user_id'),
      title: json.getStringOrDefault('title'),
      registrationNumber: json.getStringOrDefault('registration_number'),
      bio: json.getStringOrDefault('bio'),
      gender: json.getStringOrDefault('gender'),
      dateOfBirth:
          DateTime.tryParse(json.getStringOrDefault('date_of_birth')) ??
              DateTime.now(),
      consultationFee: json.getStringOrDefault('consultation_fee'),
      currencyCode: json.getStringOrDefault('currency_code'),
      yearsOfExperience: json.getIntOrDefault('years_of_experience'),
      qualifications: qualificationsList,
      profilePicturePath: json.getStringOrNull('profile_picture_path'),
      isVerified: json.getBoolOrDefault('is_verified'),
      isAvailableForConsultation:
          json.getBoolOrDefault('is_available_for_consultation'),
      availabilityStatus: json.getStringOrDefault('availability_status'),
      averageRating: json.getStringOrNull('average_rating'),
      status: json.getStringOrDefault('status'),
      user: User.fromJson(json.getMapOrDefault('user')),
      specialities: json
          .getListOrDefault('specialities')
          .map((e) => DoctorSpeciality.fromJson(e))
          .toList(),
      hospitals: json
          .getListOrDefault('hospitals')
          .map((e) => HospitalDetail.fromJson(e))
          .toList(),
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'registration_number': registrationNumber,
      'bio': bio,
      'gender': gender,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'consultation_fee': consultationFee,
      'currency_code': currencyCode,
      'years_of_experience': yearsOfExperience,
      'qualifications': qualifications,
      'profile_picture_path': profilePicturePath,
      'is_verified': isVerified,
      'is_available_for_consultation': isAvailableForConsultation,
      'availability_status': availabilityStatus,
      'average_rating': averageRating,
      'status': status,
      'user': user.toJson(),
      'specialities': specialities.map((e) => e.toJson()).toList(),
      'hospitals': hospitals.map((e) => e.toJson()).toList(),
    };
  }
}
