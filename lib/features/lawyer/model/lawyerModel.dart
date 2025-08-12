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
  final double rating;
  final String? aboutMe;
  final String? achievements;
  final double? price;
  final double? netPrice;
  final double? balance;
  final List<Map<String, dynamic>> feedback;

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
    this.rating = 0.0,
    this.aboutMe,
    this.achievements,
    this.price,
    this.netPrice,
    this.balance,
    this.feedback = const [],
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
    double? rating,
    String? aboutMe,
    String? achievements,
    double? price,
    double? netPrice,
    double? balance,
    List<Map<String, dynamic>>? feedback,
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
      rating: rating ?? this.rating,
      aboutMe: aboutMe ?? this.aboutMe,
      achievements: achievements ?? this.achievements,
      price: price ?? this.price,
      netPrice: netPrice ?? this.netPrice,
      balance: balance ?? this.balance,
      feedback: feedback ?? this.feedback,
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
      'rating': rating,
      'aboutMe': aboutMe,
      'achievements': achievements,
      'price': price,
      'netPrice': netPrice,
      'balance': balance,
      'feedback': feedback,
    };
  }

  factory Lawyer.fromJson(Map<String, dynamic> json) {
    return Lawyer(
      id: json['id'] as String?,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      birthDate: json['birthDate'] as String?,
      city: json['city'] as String?,
      idImageUrl: json['idImageUrl'] as String?,
      barAssociationImageUrl: json['barAssociationImageUrl'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      specializations: List<String>.from(json['specializations'] ?? []),
      isApproved: json['isApproved'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      aboutMe: json['aboutMe'] as String?,
      achievements: json['achievements'] as String?,
      price: (json['price'] ?? 0).toDouble(),
      netPrice: (json['netPrice'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
      feedback: json['feedback'] != null
          ? List<Map<String, dynamic>>.from(
              (json['feedback'] as List).map(
                (item) => Map<String, dynamic>.from(item),
              ),
            )
          : [],
    );
  }
}
