import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../domain/repositories/auth_repository.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _status;

  AuthRepository get _authRepository => serviceLocator<AuthRepository>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: StreamBuilder(
        stream: _authRepository.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user == null
                            ? 'Not signed in'
                            : 'Signed in as ${user.displayName}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (user != null)
                        Text(
                            'Role: ${user.role.name} | Belt: ${user.beltRank.name}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loading ? null : _signInWithEmail,
                child:
                    Text(_loading ? 'Working...' : 'Sign In / Create Account'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _loading ? null : _signInWithGoogle,
                child: const Text('Continue with Google'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _loading ? null : _signOut,
                child: const Text('Sign Out'),
              ),
              if (_status != null) ...[
                const SizedBox(height: 12),
                Text(_status!, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _signInWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _status = 'Email and password are required.');
      return;
    }

    await _runAction(() =>
        _authRepository.signInWithEmail(email: email, password: password));
  }

  Future<void> _signInWithGoogle() async {
    await _runAction(_authRepository.signInWithGoogle);
  }

  Future<void> _signOut() async {
    await _runAction(_authRepository.signOut);
  }

  Future<void> _runAction(Future<void> Function() action) async {
    setState(() {
      _loading = true;
      _status = null;
    });

    try {
      await action();
      if (!mounted) return;
      setState(() => _status = 'Success');
    } catch (error) {
      if (!mounted) return;
      setState(() => _status = error.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }
}
