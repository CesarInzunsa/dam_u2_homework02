import 'package:flutter/material.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return _drawBody();
  }

  Widget _drawBody() {
    switch (_index) {
      case 1:
        return _drawSignIn();
      default:
        return _loginHome();
    }
  }

  Widget _loginHome() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Icon(Icons.supervised_user_circle_outlined, size: 30),
      ),
      body: _drawLoginOptions(),
    );
  }

  Widget _drawSignIn() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Icon(Icons.supervised_user_circle_outlined, size: 30),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _index = 0;
              });
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: _drawSignInOption(),
    );
  }

  Widget _drawSignInOption() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              controller: userNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                hintText: 'Enter your username',
                icon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter your password',
                icon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 250),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('This feature is not available yet'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!(userNameController.text == 'admin' &&
                        passwordController.text == 'admin')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid username or password'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );

                    userNameController.clear();
                    passwordController.clear();
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _drawLoginOptions() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Welcome to my fabulous app!',
            style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 200),
          _drawSocialLoginButton('Login with Google',
              const Icon(Icons.g_mobiledata), Colors.white, Colors.black),
          _drawSocialLoginButton('Login with Apple', const Icon(Icons.apple),
              Colors.black, Colors.white),
          _drawExistingAccountLoginPrompt(),
        ],
      ),
    );
  }

  Widget _drawExistingAccountLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Have an account already?',
          style: TextStyle(color: Colors.grey[700]),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _index = 1;
            });
          },
          child: const Text(
            'Log in',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _drawSocialLoginButton(
      String text, Icon icon, Color background, Color foreground) {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This feature is not available yet'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      icon: icon,
      label: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: foreground,
        backgroundColor: background,
        minimumSize: const Size(88, 36),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    );
  }
}
