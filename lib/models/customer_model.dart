// Update Customer model
class Customer {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? address;
  final String? profileImagePath;

  Customer({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.address,
    this.profileImagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'profile_image_path': profileImagePath,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
      address: map['address'],
      profileImagePath: map['profile_image_path'],
    );
  }

  Customer copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? address,
    String? profileImagePath,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  // Add this factory constructor to your Customer class
factory Customer.empty() {
  return Customer(
    id: null,
    name: '',
    email: '',
    password: '',
    phone: null,
    address: null,
  );
}

}
