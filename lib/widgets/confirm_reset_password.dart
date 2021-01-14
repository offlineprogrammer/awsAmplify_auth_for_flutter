import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:auth_for_flutter/screens/next_screen.dart';
import 'package:flutter/material.dart';

class ConfirmResetPassword extends StatelessWidget {
  final codeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final String userName;
  final Function setError;

  ConfirmResetPassword(this.userName, this.setError);

  void _confirm_password_reset(BuildContext context) async {
    try {
      await Amplify.Auth.confirmPassword(
          username: this.userName,
          newPassword: passwordController.text.trim(),
          confirmationCode: codeController.text.trim());
      _go_to_NextScreen(context);
    } on AuthError catch (e) {
      setError(e);
    }
  }

  void _go_to_NextScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return NextScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          TextFormField(
            enableSuggestions: false,
            decoration: const InputDecoration(
              icon: Icon(Icons.email),
              hintText: 'Email',
              labelText: 'Email *',
            ),
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              icon: Icon(Icons.lock),
              hintText: 'New Password',
              labelText: 'New Password *',
            ),
            controller: passwordController,
          ),
          TextFormField(
              controller: codeController,
              decoration: const InputDecoration(
                icon: Icon(Icons.confirmation_number),
                hintText: 'The code we sent you',
                labelText: 'Confirmation Code *',
              )),
          FlatButton(
            textColor: Colors.black, // Theme.of(context).primaryColor,
            color: Colors.amber,
            onPressed: () => _confirm_password_reset(context),
            child: Text(
              'Reset Password & Sign In',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
