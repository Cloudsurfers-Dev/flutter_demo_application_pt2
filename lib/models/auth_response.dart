class AuthResponse {
  String? token;

  AuthResponse({
    this.token,
  });

  AuthResponse.fromJson(Map<String, dynamic> json) {
    token = json["token"];
  }
}
