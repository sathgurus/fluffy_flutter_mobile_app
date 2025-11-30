import 'package:fluffy/modules/auth/model/default_service_file_model.dart';


class CategoryModel {
  String? id;
  String name;
  String? businessOwnerId;
  List<DefaultServiceModel> services;

  CategoryModel({
    this.id,
    required this.name,
    this.businessOwnerId,
    required this.services,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
      businessOwnerId: json['businessOwnerId'],
      services: (json['services'] as List<dynamic>? ?? [])
          .map((e) => DefaultServiceModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'businessOwnerId': businessOwnerId,
      'services': services.map((e) => e.toJson()).toList(),
    };
  }
}
