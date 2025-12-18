import 'dart:io';

import 'package:api_http_client/api_http_client.dart';

class MedicalRecordRepository {
  MedicalRecordRepository({
    required MedicalRecordService service,
  }) : _service = service;

  final MedicalRecordService _service;

  // get medical records  
  Response<String, MedicalRecordResponse> getMedicalRecords() async {
    final response = await _service.getMedicalRecords();
    return response;
  }

// get document type 
  Response<String, DocumentTypeResponse> getDocumentTypes() async  {
    final response = await _service.getDocumentTypes();
    return response;
  }

  Response<String, MedicalRecordDetails> recordDetails({
    required String recordId,
  }) async {
    final response = await _service.recordDetails(recordId: recordId);
    return response;
  }

    Response<String, String> uploadMedicalRecord({
    required File file,
    required String documentTypeId,
    required String description,
  }) async { 
    final response = await _service.uploadMedicalRecord(
      file: file,
      documentTypeId: documentTypeId,
      description: description,
    );
    return response;
  }

  // delete medical record 
  Response<String, String> deleteMedicalRecord({
    required String recordId,
  }) async {
    final response = await _service.deleteMedicalRecord(recordId: recordId);
    return response;
  }

  
}
