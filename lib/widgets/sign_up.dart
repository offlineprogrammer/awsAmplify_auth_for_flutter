import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:auth_for_flutter/account_screens_enum.dart';
import 'package:auth_for_flutter/widgets/confirm_signup.dart';
import 'package:auth_for_flutter/widgets/error_view.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  final Function _displayAccountWidget;

  const SignUpView(this._displayAccountWidget);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isSignedUp = false;
  DateTime signupDate;

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

  void _signUp(BuildContext context) async {
    try {
      Map<String, dynamic> userAttributes = {
        "email": emailController.text.trim(),
        "preferred_username": emailController.text.trim(),
        // additional attributes as needed
      };
      SignUpResult res = await Amplify.Auth.signUp(
          username: emailController.text.trim(),
          password: passwordController.text.trim(),
          options: CognitoSignUpOptions(userAttributes: userAttributes));

      print(res.isSignUpComplete);
      setState(() {
        _isSignedUp = true;
      });
    } on AuthError catch (error) {
      _setError(error);
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
                    visible: !_isSignedUp,
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
                      TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Password',
                          labelText: 'Password *',
                        ),
                        controller: passwordController,
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      FlatButton(
                        textColor:
                            Colors.black, // Theme.of(context).primaryColor,
                        color: Colors.amber,
                        onPressed: () => _signUp(context),
                        child: Text(
                          'Create Account',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      FlatButton(
                        height: 5,
                        onPressed: _displaySignIn,
                        child: Text(
                          'Already registered? Sign In',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    ]),
                  ),
                  Visibility(
                      visible: _isSignedUp,
                      child: Column(children: [
                        ConfirmSignup(emailController.text.trim(), _setError),
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

  void _displaySignIn() {
    widget._displayAccountWidget(AccountStatus.sign_in.index);
  }
}
