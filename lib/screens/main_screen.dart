import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:auth_for_flutter/account_screens_enum.dart';
import 'package:auth_for_flutter/screens/next_screen.dart';
import 'package:auth_for_flutter/widgets/reset_password.dart';
import 'package:auth_for_flutter/widgets/sign_in.dart';
import 'package:auth_for_flutter/widgets/sign_up.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _accountWidget;

  @override
  initState() {
    super.initState();
    _fetchSession();
  }

  void _fetchSession() async {
    // Sign out before in case a user is already signed in
    try {
      await Amplify.Auth.signOut();
    } on AuthError catch (e) {
      print(e);
    }
    _accountWidget = AccountStatus.sign_in.index;
    _displayAccountWidget(_accountWidget);
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

  void _displayAccountWidget(int accountStatus) {
    setState(() {
      _accountWidget = AccountStatus.values[accountStatus];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BatMan App'),
      ),
      body: Container(
        color: Color(0xffE1E5E4),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                color: Color(0xffE1E5E4),
                height: 200,
                child: Image.asset(
                  'assets/images/applogo.png',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Visibility(
                    visible: _accountWidget == AccountStatus.sign_in,
                    child: SignInView(_displayAccountWidget),
                  ),
                  Visibility(
                    visible: _accountWidget == AccountStatus.sign_up,
                    child: SignUpView(_displayAccountWidget),
                  ),
                  Visibility(
                    visible: _accountWidget == AccountStatus.reset_password,
                    child: ResetPasswordView(_displayAccountWidget),
                  ),
                  Visibility(
                    visible: _accountWidget == AccountStatus.main_screen,
                    child: NextScreen(),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
