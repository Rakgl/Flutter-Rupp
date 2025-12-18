import 'package:api_http_client/api_http_client.dart';

class DoctorResponse extends BaseResponse {
  DoctorResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getListOrDefault('data');
    doctors = data.map((e) => DoctorDetailModel.fromJson(e)).toList();

    isReachMax = json.getBoolOrDefault('reach_max');
  }

  late List<DoctorDetailModel> doctors;
  late bool isReachMax;
}

class DoctorModel {
  final String id;
  final String userId;
  final String title;
  final String registrationNumber;
  final String bio;
  final String gender;
  final String consultationFee;
  final String currencyCode;
  final int yearsOfExperience;
  final String? profilePicturePath;
  final bool isAvailableForConsultation;
  final String availabilityStatus;
  final String averageRating;
  final User user;
  final List<DoctorSpeciality> specialities;

  DoctorModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.registrationNumber,
    required this.bio,
    required this.gender,
    required this.consultationFee,
    required this.currencyCode,
    required this.yearsOfExperience,
    required this.profilePicturePath,
    required this.isAvailableForConsultation,
    required this.availabilityStatus,
    required this.averageRating,
    required this.user,
    required this.specialities,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json.getStringOrDefault('id'),
      userId: json.getStringOrDefault('user_id'),
      title: json.getStringOrDefault('title'),
      registrationNumber: json.getStringOrDefault('registration_number'),
      bio: json.getStringOrDefault('bio'),
      gender: json.getStringOrDefault('gender'),
      consultationFee: json.getStringOrDefault('consultation_fee'),
      currencyCode: json.getStringOrDefault('currency_code'),
      yearsOfExperience: json.getIntOrDefault('years_of_experience'),
      profilePicturePath: json['profile_picture_path'] as String?,
      isAvailableForConsultation:
          json.getBoolOrDefault('is_available_for_consultation'),
      availabilityStatus: json.getStringOrDefault('availability_status'),
      averageRating: json.getStringOrDefault('average_rating'),
      user: User.fromJson(json.getMapOrDefault('user')),
      specialities: json
          .getListOrDefault('specialities')
          .map((e) => DoctorSpeciality.fromJson(e))
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
      'consultation_fee': consultationFee,
      'currency_code': currencyCode,
      'years_of_experience': yearsOfExperience,
      'profile_picture_path': profilePicturePath,
      'is_available_for_consultation': isAvailableForConsultation,
      'availability_status': availabilityStatus,
      'average_rating': averageRating,
      'user': user.toJson(),
      'specialities': specialities.map((e) => e.toJson()).toList(),
    };
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String? image;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json.getStringOrDefault('id'),
      name: json.getStringOrDefault('name'),
      email: json.getStringOrDefault('email'),
      image: json.getStringOrDefault('image'),
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
    };
  }
}

class DoctorSpeciality {
  final String id;
  final String name;
  final Pivot pivot;

  DoctorSpeciality({
    required this.id,
    required this.name,
    required this.pivot,
  });

  factory DoctorSpeciality.fromJson(Map<String, dynamic> json) {
    return DoctorSpeciality(
      id: json.getStringOrDefault('id'),
      name: json.getStringOrDefault('name'),
      pivot: Pivot.fromJson(json.getMapOrDefault('pivot')),
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pivot': pivot.toJson(),
    };
  }
}

class Pivot {
  final String doctorId;
  final String DoctorspecialityId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pivot({
    required this.doctorId,
    required this.DoctorspecialityId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      doctorId: json.getStringOrDefault('doctor_id'),
      DoctorspecialityId: json.getStringOrDefault('Doctorspeciality_id'),
      createdAt: DateTime.tryParse(json.getStringOrDefault('created_at')) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json.getStringOrDefault('updated_at')) ??
          DateTime.now(),
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'doctor_id': doctorId,
      'Doctorspeciality_id': DoctorspecialityId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
