class ClientModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  // final String password;
  final String? imageUrl;
  final bool isDelete;

  const ClientModel({
    required this.isDelete,
    this.id,
    this.imageUrl,
    required this.name,
    required this.email,
    required this.phone,
    // required this.password,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json, [String? id]) {
    return ClientModel(
      id: id ?? json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      // password: json['password'] ?? '',
      imageUrl: json['imageUrl'],
      isDelete: json['isDelete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      // 'password': password,
      'imageUrl': imageUrl,
      'isDelete': isDelete,
    };
  }
}
