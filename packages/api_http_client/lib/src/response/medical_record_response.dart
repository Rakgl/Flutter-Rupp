import 'package:api_http_client/api_http_client.dart';

class MedicalRecordResponse extends BaseResponse {
  MedicalRecordResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    final data = json.getListOrDefault('data');
    records = data.map((item) => MedicalRecord.fromJson(item)).toList();
  }

  late List<MedicalRecord> records;
}

class MedicalRecordDetails extends BaseResponse {
  MedicalRecordDetails.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    final data = json.getMapOrDefault('data');
    record = MedicalRecord.fromJson(data);
  }

  late MedicalRecord record;
}

class MedicalRecord {
  final String id;
  final String documentTypeId;
  final String documentTypeName;
  final String fileUrl;
  final String fileName;
  final String description;
  final String uploadedAt;

  MedicalRecord({
    required this.id,
    required this.documentTypeId,
    required this.documentTypeName,
    required this.fileUrl,
    required this.fileName,
    required this.description,
    required this.uploadedAt,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json.getStringOrDefault('id'),
      documentTypeId: json.getStringOrDefault('document_type_id'),
      documentTypeName: json.getStringOrDefault('document_type_name'),
      fileUrl: json.getStringOrDefault('file_url'),
      fileName: json.getStringOrDefault('file_name'),
      description: json.getStringOrDefault('description'),
      uploadedAt: json.getStringOrDefault('uploaded_at'),
    );
  }
}
