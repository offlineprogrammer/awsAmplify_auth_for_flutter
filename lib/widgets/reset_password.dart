import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:auth_for_flutter/account_screens_enum.dart';
import 'package:auth_for_flutter/widgets/confirm_reset_password.dart';
import 'package:auth_for_flutter/widgets/error_view.dart';
import 'package:flutter/material.dart';

class ResetPasswordView extends StatefulWidget {
  final Function _displayAccountWidget;

  const ResetPasswordView(this._displayAccountWidget);

  @override
  _ResetPasswordViewState createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final emailController = TextEditingController();
  bool _isPasswordReset = false;

  String _signUpError = "";
  List<String> _signUpExceptions = [];

  @override
  void initState() {
    super.initState();
  }

  void _setError(AuthError error) {
    setState(() {
      _signUpError = error.cause;
      _signUpExceptions.clear();
      error.exceptionList.forEach((el) {
        _signUpExceptions.add(el.exception);
      });
    });
  }

  void _resetPassword(BuildContext context) async {
    try {
      ResetPasswordResult res = await Amplify.Auth.resetPassword(
        username: emailController.text.trim(),
      );

      setState(() {
        _isPasswordReset = true;
      });
    } on AuthError catch (e) {
      setState(() {
        _signUpError = e.cause;
        _signUpExceptions.clear();
        e.exceptionList.forEach((el) {
          _signUpExceptions.add(el.exception);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Visibility(
                    visible: !_isPasswordReset,
                    child: Column(children: [
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
                      const Padding(padding: EdgeInsets.all(10.0)),
                      FlatButton(
                        textColor:
                            Colors.black, // Theme.of(context).primaryColor,
                        color: Colors.amber,
                        onPressed: () => _resetPassword(context),
                        child: Text(
                          'Reset Password',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      FlatButton(
                        height: 5,
                        onPressed: _displayCreateAccount,
                        child: Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    ]),
                  ),
                  Visibility(
                      visible: _isPasswordReset,
                      child: Column(children: [
                        ConfirmResetPassword(
                            emailController.text.trim(), _setError),
                      ])),
                  ErrorView(_signUpError, _signUpExceptions)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _displayCreateAccount() {
    widget._displayAccountWidget(AccountStatus.sign_up.index);
  }
}
