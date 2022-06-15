import 'package:clean_framework/clean_framework.dart';
import 'package:feature_flag/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FeatureBuilder<bool>(
          flagKey: 'newTitle',
          defaultValue: false,
          builder: (context, showNewTitle) {
            return Text(
              showNewTitle ? 'Feature Flags Demo' : 'Feature Widget',
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 64),
                child: FlutterLogo(
                  size: 64,
                  style: FlutterLogoStyle.horizontal,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Login with your email',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'name@example.com',
                  labelText: 'Email Address',
                ),
                validator: (value) {
                  final emailRegex = RegExp(
                    r'^.+@[a-zA-Z0-9\-]+\.?[a-zA-Z0-9\-]+\.{1}[a-zA-Z]+(\.?[a-zA-Z]+)$',
                  );

                  if (emailRegex.hasMatch(value ?? '')) return null;
                  return 'Invalid Email!';
                },
                onChanged: (value) => _email = value,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _navigateToHome(context, email: _email);
                  }
                },
                child: const Text('LOGIN'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _navigateToHome(context),
                child: const Text('SKIP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context, {String? email}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(email: email),
      ),
    );
  }
}
