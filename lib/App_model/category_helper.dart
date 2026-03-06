class CategoryHelper {
  final int id;
  final String name;

  CategoryHelper({required this.id, required this.name});

  // For dropdown display
  @override
  String toString() => name;

  // Create from API response
  factory CategoryHelper.fromJson(Map<String, dynamic> json) {
    return CategoryHelper(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  // Convert to Map for API calls
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Get category ID as string for API
  String get categoryId => id.toString();
}
