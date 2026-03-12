import 'package:api_http_client/api_http_client.dart';

class PetResponse extends BaseResponse {
  PetResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getListOrDefault('data');
    pets = List<Pet>.from(data.map((x) => Pet.fromJson(x)));

    // Handle root-level pagination values
    currentPage = json.getIntOrDefault('current_page', defaultValue: 1);
    lastPage = json.getIntOrDefault('last_page', defaultValue: 1);
    total = json.getIntOrDefault('total', defaultValue: 0);
  }

  late List<Pet> pets;
  int currentPage = 1;
  int lastPage = 1;
  int total = 0;

  bool get isReachMax => currentPage >= lastPage;
}

class Pet {
  final String id;
  final String name;
  final String? species;
  final String? breed;
  final String? weight;
  final String? dateOfBirth;
  final String? imageUrl;
  final String? medicalNotes;
  final String? price;
  final Category? category;

  Pet({
    required this.id,
    required this.name,
    this.species,
    this.breed,
    this.weight,
    this.dateOfBirth,
    this.imageUrl,
    this.medicalNotes,
    this.price,
    this.category,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      species: json['species'] as String?,
      breed: json['breed'] as String?,
      weight: json['weight']
          ?.toString(), // Ensure double or string maps to string safely
      dateOfBirth: json['date_of_birth'] as String?,
      imageUrl: json['image_url'] as String?,
      medicalNotes: json['medical_notes'] as String?,
      price: json['price'] as String?,
      category: json['category'] != null
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }
}
