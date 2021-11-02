class Users {
  Users({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Users.fromMap(Map<String, dynamic> data) {
    return Users(id: data['id'], name: data['name'], email: data['email']);
  }

  final String id;
  final String name;
  final String email;
}
