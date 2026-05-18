class TopicModel {
  final int id;
  final String title;
  final String? description;
  final double price;
  final bool isFree;
  final String? createdAt;

  TopicModel({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    required this.isFree,
    this.createdAt,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      isFree: json['is_free'] == true || json['is_free'] == 1,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'is_free': isFree,
    };
  }
}
