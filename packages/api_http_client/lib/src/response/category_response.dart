import 'package:api_http_client/api_http_client.dart';

class CategoryResponse extends BaseResponse {
  CategoryResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    List<dynamic> dataList = [];
    if (json.containsKey('data')) {
      dataList = json.getListOrDefault('data');
    } else {
      // Sometimes it might not be paginated, fallback to root if it was a list (though not typical for BaseResponse)
      dataList = json.getListOrDefault('data');
    }
    categories = dataList.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();

    currentPage = json.getIntOrDefault('current_page', defaultValue: 1);
    lastPage = json.getIntOrDefault('last_page', defaultValue: 1);
    total = json.getIntOrDefault('total', defaultValue: 0);
  }

  late List<Category> categories = [];
  int currentPage = 1;
  int lastPage = 1;
  int total = 0;

  bool get isReachMax => currentPage >= lastPage;
}

class Category {
  final String id;
  final Map<String, dynamic> nameObj;
  final Map<String, dynamic> descriptionObj;
  final String? imageUrl;
  final String? type;

  // Seamless backwards compatibility string accessor prioritizing English
  String get name => nameObj['en']?.toString() ?? nameObj['kh']?.toString() ?? 'Category';
  String get description => descriptionObj['en']?.toString() ?? descriptionObj['kh']?.toString() ?? '';

  const Category({
    required this.id,
    required this.nameObj,
    required this.descriptionObj,
    this.imageUrl,
    this.type,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final nameField = json['name'];
    Map<String, dynamic> parsedName = {};
    
    if (nameField is Map<String, dynamic>) {
      parsedName = nameField;
    } else if (nameField is String) {
      // Fallback in case backend sometimes sends naked strings
      parsedName = {'en': nameField};
    }

    final descField = json['description'];
    Map<String, dynamic> parsedDesc = {};
    
    if (descField is Map<String, dynamic>) {
      parsedDesc = descField;
    } else if (descField is String) {
      parsedDesc = {'en': descField};
    }

    return Category(
      id: json['id']?.toString() ?? '',
      nameObj: parsedName,
      descriptionObj: parsedDesc,
      imageUrl: json['image_url']?.toString(),
      type: json['type']?.toString(),
    );
  }
}
