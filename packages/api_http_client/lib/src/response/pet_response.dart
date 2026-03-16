import 'package:api_http_client/api_http_client.dart';

class PetResponse extends BaseResponse {
  PetResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getListOrDefault('data');
    
    // Check if the data contains listings or direct pets
    if (data.isNotEmpty && (data.first as Map<String, dynamic>).containsKey('pet')) {
      final listingsList = List<PetListing>.from(
        data.map((x) => PetListing.fromJson(x as Map<String, dynamic>)),
      );
      listings = listingsList;
      pets = listingsList.map((l) => l.pet).toList();
    } else {
      pets = List<Pet>.from(
        data.map((x) => Pet.fromJson(x as Map<String, dynamic>)),
      );
      listings = [];
    }

    if (json.containsKey('meta')) {
      final meta = json['meta'] as Map<String, dynamic>;
      currentPage = meta.getIntOrDefault('current_page', defaultValue: 1);
      lastPage = meta.getIntOrDefault('last_page', defaultValue: 1);
      total = meta.getIntOrDefault('total', defaultValue: 0);
    } else {
      currentPage = json.getIntOrDefault('current_page', defaultValue: 1);
      lastPage = json.getIntOrDefault('last_page', defaultValue: 1);
      total = json.getIntOrDefault('total', defaultValue: 0);
    }

    if (json.containsKey('links')) {
      final linksJson = json['links'] as Map<String, dynamic>;
      links = PetResponseLinks.fromJson(linksJson);
    }
  }

  late List<Pet> pets = [];
  List<PetListing>? listings;
  int currentPage = 1;
  int lastPage = 1;
  int total = 0;
  PetResponseLinks? links;

  bool get isReachMax => currentPage >= lastPage;
}

class PetResponseLinks {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  PetResponseLinks({this.first, this.last, this.prev, this.next});

  factory PetResponseLinks.fromJson(Map<String, dynamic> json) {
    return PetResponseLinks(
      first: json['first']?.toString(),
      last: json['last']?.toString(),
      prev: json['prev']?.toString(),
      next: json['next']?.toString(),
    );
  }
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
  final bool isFavorite;
  final DateTime? createdAt;

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
    this.isFavorite = false,
    this.createdAt,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    Category? category;
    if (json['category'] != null) {
      category = Category.fromJson(json['category'] as Map<String, dynamic>);
    } else if (json['category_name'] != null) {
      category = Category(
        id: '', 
        name: json['category_name'] as String, 
        description: '',
      );
    }

    return Pet(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      species: json['species']?.toString(),
      breed: json['breed']?.toString(),
      weight: json['weight']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      imageUrl: json['image_url']?.toString(),
      medicalNotes: json['medical_notes']?.toString(),
      price: json['price']?.toString(),
      category: category,
      isFavorite: json['is_favorite'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) 
          : null,
    );
  }
}

class PetListing {
  final String id; // listing_id
  final String listingType; // SALE or ADOPTION
  final String price;
  final String description;
  final String status;
  final Pet pet;
  final DateTime createdAt;

  PetListing({
    required this.id,
    required this.listingType,
    required this.price,
    required this.description,
    required this.status,
    required this.pet,
    required this.createdAt,
  });

  factory PetListing.fromJson(Map<String, dynamic> json) {
    return PetListing(
      id: json['id']?.toString() ?? '',
      listingType: json['listing_type']?.toString() ?? 'SALE',
      price: json['price']?.toString() ?? '0',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? 'AVAILABLE',
      pet: Pet.fromJson(json['pet'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at']?.toString() ?? DateTime.now().toIso8601String()),
    );
  }
}
