class AuthProvider {
  String? _token;

  setToken(String? token) {
    _token = token;
  }

  String? get token {
    return _token;
  }
}
