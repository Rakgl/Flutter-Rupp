import 'dart:io';

import 'package:dio/dio.dart' show FormData, MultipartFile;
import 'package:http_client/http_client.dart';

import '../../api_http_client.dart';

class MedicalRecordService extends ApiHttpClient {
  MedicalRecordService({required super.httpClient}) : _httpClient = httpClient;

  final HttpClient _httpClient;

  Response<String, MedicalRecordResponse> getMedicalRecords() async {
    try {
      final response = await _httpClient.get('/medical-records');
      final res = MedicalRecordResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to fetch medical records');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  Response<String, DocumentTypeResponse> getDocumentTypes() async {
    try {
      final response = await _httpClient.get('/get-document-types');
      final res = DocumentTypeResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to fetch document types');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // record-details
  Response<String, MedicalRecordDetails> recordDetails({
    required String recordId,
  }) async {
    try {
      final response = await _httpClient.get('/medical-records/$recordId');
      final res = MedicalRecordDetails.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to fetch medical record details');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // upload medical records
  Response<String, String> uploadMedicalRecord({
    required File file,
    required String documentTypeId,
    required String description,
  }) async {
    try {
      final pattern = RegExp(r'\.(jpg|jpeg|png|pdf)$', caseSensitive: false);
      if (!pattern.hasMatch(file.path)) {
        return const Left('Please select a valid file type (JPG, PNG, PDF)');
      }

      final localFile = File(file.path);
      if (!await localFile.exists()) {
        return const Left('Error: The selected file could not be found.');
      }

      final filename = file.path.split('/').last;
      final recordFile = await MultipartFile.fromFile(
        file.path,
        filename: filename,
      );

      // 1. Create a FormData object from a map.
      final formData = FormData.fromMap({
        'document_type_id': documentTypeId,
        'description': description,
        'record_file': recordFile,
      });

      final response = await _httpClient.post(
        '/medical-records',
        body: formData,
      );

      if (response['success'] == true) {
        return Right(response['message']);
      } else {
        return Left(response['message']);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return Left(
        e.toString(),
      );
    }
  }

  // delete medical record
  Response<String, String> deleteMedicalRecord({
    required String recordId,
  }) async {
    try {
      final response = await _httpClient.delete('/medical-records/$recordId');

      if (response['success'] == true) {
        return Right(response['message']);
      } else {
        return Left(response['message']);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }
}
