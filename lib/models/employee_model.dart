class Employee {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String? phone;
  final String? address;
  final double? salary;
  final String? profileImagePath;

  Employee({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.phone,
    this.address,
    this.salary,
    this.profileImagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'phone': phone,
      'address': address,
      'salary': salary,
      'profile_image_path': profileImagePath,
      
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      phone: map['phone'],
      address: map['address'],
      salary: map['salary'] != null ? map['salary'].toDouble() : null,
      profileImagePath: map['profile_image_path'],
    );
  }

  Employee copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? role,
    String? phone,
    String? address,
    double? salary,
    String? profileImagePath,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      salary: salary ?? this.salary,
      profileImagePath: profileImagePath ?? this.profileImagePath

    );
  }
}