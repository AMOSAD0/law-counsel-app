class ClientModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String password;

  const ClientModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json, [String? id]) {
    return ClientModel(
      id: id ?? json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
