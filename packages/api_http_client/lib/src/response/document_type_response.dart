import 'package:api_http_client/api_http_client.dart';
import 'package:equatable/equatable.dart';

class DocumentTypeResponse extends BaseResponse {
  DocumentTypeResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
        final data = json.getListOrDefault('data');
        documentTypes = data.map((item) => DocumentType.fromJson(item)).toList();
  }

  late List<DocumentType> documentTypes;

}

class DocumentType extends Equatable {
  final String id; 
  final String name; 

  const DocumentType({
    required this.id,
    required this.name,
  });


  factory DocumentType.fromJson(Map<String, dynamic> json) {
    return DocumentType(
      id: json.getStringOrDefault('id'),
      name: json.getStringOrDefault('name'),
    );
  }

  @override
  List<Object?> get props => [id, name];

}
   