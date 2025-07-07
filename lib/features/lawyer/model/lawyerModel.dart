class Lawyer {
  final String? id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? birthDate;
  final String? city;
  final String? idImageUrl;
  final String? barAssociationImageUrl;
  final String? profileImageUrl;
  final List<String> specializations;
  final bool isApproved;

  Lawyer({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.birthDate,
    this.city,
    this.idImageUrl,
    this.barAssociationImageUrl,
    this.profileImageUrl,
    this.specializations = const [],
    this.isApproved = false,
  });
  Lawyer copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? birthDate,
    String? city,
    String? idImageUrl,
    String? barAssociationImageUrl,
    String? profileImageUrl,
    List<String>? specializations,
    bool? isApproved,
  }) {
    return Lawyer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthDate: birthDate ?? this.birthDate,
      city: city ?? this.city,
      idImageUrl: idImageUrl ?? this.idImageUrl,
      barAssociationImageUrl:
          barAssociationImageUrl ?? this.barAssociationImageUrl,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      specializations: specializations ?? this.specializations,
      isApproved: isApproved ?? this.isApproved,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'city': city,
      'idImageUrl': idImageUrl,
      'barAssociationImageUrl': barAssociationImageUrl,
      'profileImageUrl': profileImageUrl,
      'specializations': specializations,
      'isApproved': isApproved,
    };
  }

  factory Lawyer.fromJson(Map<String, dynamic> json) {
    return Lawyer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      birthDate: json['birthDate'] ?? '',
      city: json['city'] ?? '',
      idImageUrl: json['idImageUrl'] ?? '',
      barAssociationImageUrl: json['barAssociationImageUrl'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      specializations: List<String>.from(json['specializations'] ?? []),
      isApproved: json['isApproved'],
    );
  }

  // من Firestore: استخدمه لو بتتعامل مع DocumentSnapshot
  // factory Lawyer.fromDocument(String docId, Map<String, dynamic> json) {
  //   return Lawyer(
  //     id: docId,
  //     name: json['name'] ?? '',
  //     email: json['email'] ?? '',
  //     phoneNumber: json['phoneNumber'] ?? '',
  //     birthDate: DateTime.tryParse(json['birthDate'] ?? '') ?? DateTime(2000),
  //     city: json['city'] ?? '',
  //     idImageUrl: json['idImageUrl'] ?? '',
  //     barAssociationImageUrl: json['barAssociationImageUrl'] ?? '',
  //     profileImageUrl: json['profileImageUrl'] ?? '',
  //   );
  // }
}
