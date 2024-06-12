class UserLogin {
  final String? email;
  final String? password;

  UserLogin({this.email, this.password});

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class UserSignUp {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? userType;
  final String? identification;
  final String? uniqueKey;

  UserSignUp(
      {this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.userType,
      this.identification,
      this.uniqueKey});

  factory UserSignUp.fromJson(Map<String, dynamic> json) {
    return UserSignUp(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      password: json['password'],
      userType: json['user_type'],
      identification: json['identification_number'],
      uniqueKey: json['date_of_birth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'user_type': userType,
      'identification_number': identification,
      'date_of_birth': uniqueKey
    };
  }
}
