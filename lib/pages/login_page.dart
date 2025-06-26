import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isLogin = true;
  String? _erro;
  bool _loading = false;

  Future<void> _autenticar() async {
    setState(() { _erro = null; _loading = true; });
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _senhaController.text.trim(),
        );
        Navigator.of(context).pop(_emailController.text.trim());
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _senhaController.text.trim(),
        );
        Navigator.of(context).pop(_emailController.text.trim());
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'A senha fornecida é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Já existe uma conta para este e-mail.';
      } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'E-mail ou senha inválidos.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'O e-mail digitado não é válido.';
      } else {
        errorMessage = e.message ?? 'Erro de autenticação desconhecido.';
      }
      setState(() => _erro = errorMessage);
    } catch (e) {
      setState(() => _erro = 'Erro inesperado.');
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onBackground;
    final fillColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.04);
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                style: TextStyle(color: color),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: color.withOpacity(0.7)),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _senhaController,
                style: TextStyle(color: color),
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: color.withOpacity(0.7)),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                obscureText: true,
              ),
              if (_erro != null) ...[
                const SizedBox(height: 16),
                Text(_erro!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _autenticar,
                  child: _loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(_isLogin ? 'Entrar' : 'Cadastrar'),
                ),
              ),
              TextButton(
                onPressed: _loading ? null : () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin ? 'Não tem conta? Cadastre-se' : 'Já tem conta? Faça login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 