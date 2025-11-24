class ServiceModel {
  String name; // Category Name
  List<ServiceItem> services;

  ServiceModel({
    required this.name,
    required this.services,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      name: json["name"],
      services: (json["services"] as List)
          .map((e) => ServiceItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "services": services.map((e) => e.toJson()).toList(),
    };
  }
}

class ServiceItem {
  String name;
  double price;

  ServiceItem({
    required this.name,
    this.price = 0,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      name: json["name"],
      price: (json["price"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
    };
  }
}
