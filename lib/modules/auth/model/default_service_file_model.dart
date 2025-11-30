class DefaultServiceModel {
  String? id;
  String name;

  DefaultServiceModel({this.id, required this.name});

  factory DefaultServiceModel.fromJson(Map<String, dynamic> json) {
    return DefaultServiceModel(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}
