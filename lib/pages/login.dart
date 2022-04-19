import 'package:demo_application/models/auth_request.dart';
import 'package:demo_application/providers/api_provider.dart';
import 'package:demo_application/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../generated/l10n.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  String? _email;
  String? _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildEmail() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: "Email",
          border: OutlineInputBorder(),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Email richiesta';
          }
          return null;
        },
        onSaved: (String? value) {
          _email = value;
        },
      ),
    );
  }

  Widget _buildPassword() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Password richiesta';
          }
          return null;
        },
        onSaved: (String? value) {
          _password = value;
        },
      ),
    );
  }

  get authenticated {
    return GetIt.I<AuthProvider>().token != null;
  }

  Widget itemsButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            GetIt.I<ApiProvider>().items().then((response) {
              print(response);
            }).onError((error, stackTrace) {
              print(error);
            });
          },
          child: SizedBox(
            width: 200,
            height: 50,
            child: Center(
              child: Text(
                S.current.loginItemsButton,
                textScaleFactor: 1.5,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.loginTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 200,
                  height: 100,
                  child: FlutterLogo(),
                ),
                const SizedBox(height: 8),
                _buildEmail(),
                _buildPassword(),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    _formKey.currentState!.save();

                    print(_email);
                    print(_password);

                    AuthRequest request = AuthRequest(
                      email: _email,
                      password: _password,
                    );

                    GetIt.I<ApiProvider>().auth(request).then((response) {
                      print(response?.token);

                      if (response != null && response.token != null) {
                        setState(() {
                          GetIt.I<AuthProvider>().setToken(response.token);
                        });
                      }
                    }).onError((error, stackTrace) {
                      print(error);
                    });
                  },
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: Center(
                      child: Text(
                        S.current.loginButton,
                        textScaleFactor: 1.5,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: authenticated,
                  child: itemsButton(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
