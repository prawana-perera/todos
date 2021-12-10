class User {
  String? id;
  String email;
  String name;

  User(this.id, this.email, this.name);

  User.create(this.email, this.name);
}
