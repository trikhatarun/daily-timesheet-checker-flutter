class TickUser {
  final int _id;
  final String _email;
  final String _firstName;
  final String _lastName;

  TickUser(this._id, this._email, this._firstName, this._lastName);

  factory TickUser.fromJson(Map<String, dynamic> json) {
    return TickUser(
        json['id'], json['email'], json['first_name'], json['last_name']);
  }

  String get lastName => _lastName;

  String get firstName => _firstName;

  String get email => _email;

  int get id => _id;
}
