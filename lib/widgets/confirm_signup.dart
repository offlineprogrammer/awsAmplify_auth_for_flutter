import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:auth_for_flutter/screens/next_screen.dart';
import 'package:flutter/material.dart';

class ConfirmSignup extends StatelessWidget {
  final codeController = TextEditingController();
  final String userName;
  final Function setError;

  ConfirmSignup(this.userName, this.setError);

  void _skip_confirm_signup(BuildContext context) {
    _go_to_NextScreen(context);
  }

  void _confirm_signup(BuildContext context) async {
    try {
      SignUpResult res = await Amplify.Auth.confirmSignUp(
          username: this.userName,
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
              controller: codeController,
              decoration: const InputDecoration(
                icon: Icon(Icons.confirmation_number),
                hintText: 'The code we sent you',
                labelText: 'Confirmation Code *',
              )),
          FlatButton(
            textColor: Colors.black, // Theme.of(context).primaryColor,
            color: Colors.amber,
            onPressed: () => _confirm_signup(context),
            child: Text(
              'Confirm Sign Up',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
