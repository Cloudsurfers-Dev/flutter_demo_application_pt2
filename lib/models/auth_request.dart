class AuthRequest {
  String? email;
  String? password;

  AuthRequest({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["email"] = email;
    data["password"] = email;
    return data;
  }
}
