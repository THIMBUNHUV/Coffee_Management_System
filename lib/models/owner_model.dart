class Owner {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? businessName;
  final String? businessAddress;
  final String? profileImagePath;

  Owner({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.businessName,
    this.businessAddress,
    this.profileImagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'business_name': businessName,
      'business_address': businessAddress,
      'profile_image_path': profileImagePath,
    };
  }

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
      businessName: map['business_name'],
      businessAddress: map['business_address'],
      profileImagePath: map['profile_image_path'],
    );
  }

  Owner copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? businessName,
    String? businessAddress,
    String? profileImagePath,
  }) {
    return Owner(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  // Add this factory constructor to your Owner class
factory Owner.empty() {
  return Owner(
    id: null,
    name: '',
    email: '',
    password: '',
    phone: null,
    businessName: null,
    businessAddress: null,
   
  );
}
}