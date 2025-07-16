class Consultation {
  final String id;
  final String title;
  final String description;
  final String userId;
  final String lawyerId;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool deletedByClient;


  Consultation({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.lawyerId,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.deletedByClient = false,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
      'lawyerId': lawyerId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedByClient': deletedByClient,
    };
  }

  factory Consultation.fromMap(Map<String, dynamic> map) {
    return Consultation(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      userId: map['userId'] ?? '',
      lawyerId: map['lawyerId'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
      deletedByClient: map['deletedByClient'] ?? false,
    );
  }
}
