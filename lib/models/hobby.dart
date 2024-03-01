class Hobby {
  final String name;
  final String link; // Added link field
  final String category;

  Hobby({
    required this.name,
    required this.link,
    required this.category,
  });
 factory Hobby.fromMap(Map<String, dynamic> data) {
    return Hobby(
      name: data['name'],
      link: data['link'],
      category: data['category'],
    );
  }
  factory Hobby.fromJson(Map<String, dynamic> json) {
    return Hobby(
      name: json['hobby'] as String,
      link: json['link'] as String,
      category: json['category'] as String,
    );
  }
   Map<String, dynamic> toMap() {
    return {
      'name': name,
      'link': link,
      'category': category,
    };
  }
}
