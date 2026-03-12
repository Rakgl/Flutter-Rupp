import 'package:api_http_client/api_http_client.dart';

class PetDetailResponse {
  PetDetailResponse.fromJson(Map<String, dynamic> json) {
    print('[PET_DEBUG] fromJson called. Keys: ${json.keys.toList()}');
    try {
      if (json.containsKey('data') && json['data'] != null) {
        pet = Pet.fromJson(json['data'] as Map<String, dynamic>);
        print('[PET_DEBUG] Parsed from data wrapper: ${pet?.name}');
      } else if (json.containsKey('id')) {
        // Fallback: the pet properties are at the root level of the JSON
        pet = Pet.fromJson(json);
        print('[PET_DEBUG] Parsed from root: ${pet?.name}');
      } else {
        print('[PET_DEBUG] No id or data key found in JSON');
      }
    } catch (e, s) {
      print('[PET_DEBUG] Exception during fromJson: $e\n$s');
    }
  }

  Pet? pet;
}
