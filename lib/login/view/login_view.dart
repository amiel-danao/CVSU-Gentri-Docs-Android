import 'package:flutter_chat_demo/signup/view/signup_view.dart';
import 'package:auth_service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:email_validator/email_validator.dart';

import '../../api/student_controller.dart';
import '../../constants/app_constants.dart';
import '../../constants/color_constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/profile_widgets.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  LoginViewState createState() {
    return LoginViewState();
  }
}

class LoginViewState extends State<LoginView> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  Status _status = Status.uninitialized;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "amiel.tbpo@gmail.com");
    _passwordController = TextEditingController(text: "notCommonPassword123\$");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: ColorConstants.primaryColor,
      ),
      body: Stack(children: <Widget>[
        backgroundWidget(),
        Container(
          height: double.infinity,
          alignment: Alignment.topCenter,
          child: Container(
              width: 200,
              height: 150,
              child: Image.asset('images/app_logo.png')),
        ),
        const SizedBox(height: 30.0),
        Center(
          child: DecoratedBox(
            decoration:
                const BoxDecoration(color: Color.fromARGB(143, 226, 226, 226)),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 30.0),
                      ProfileAccountEmail(emailController: _emailController),
                      const SizedBox(height: 30.0),
                      ProfileAccountPassword(
                          passwordController: _passwordController,
                          label: "Password"),
                      _SubmitButton(
                        onStateChanged: (status) => setState(() {
                          _status = status;
                        }),
                        formKey: _formKey,
                        email: _emailController,
                        password: _passwordController,
                      ),
                      const SizedBox(height: 30.0),
                      _CreateAccountButton(),
                    ],
                  ),
                )),
          ),
        ),
        Positioned(
          child: _status == Status.authenticating
              ? LoadingView()
              : SizedBox.shrink(),
        )
      ]),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class _SubmitButton extends StatefulWidget {
  _SubmitButton({
    Key? key,
    required this.onStateChanged,
    required this.formKey,
    required this.email,
    required this.password,
  }) : super(key: key);

  final AuthStateCallback onStateChanged;
  final formKey;
  final TextEditingController email, password;
  final AuthService _authService = FirebaseAuthService(
    authService: FirebaseAuth.instance,
  );

  @override
  State<StatefulWidget> createState() => SubmitState();
}

class SubmitState extends State<_SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.themeColor,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      onPressed: () async {
        if (widget.formKey.currentState!.validate()) {
          try {
            widget.onStateChanged(Status.authenticating);
            await widget._authService
                .signInWithEmailAndPassword(
              email: widget.email.text,
              password: widget.password.text,
            )
                .then((value) async {
              await createUserProfileIfNotExist(value, context)
                  .then((value) {})
                  .catchError((error) {
                widget.onStateChanged(Status.authenticateError);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error.toString()),
                  ),
                );
              });
            }).catchError((error) {
              widget.onStateChanged(Status.authenticateError);
              Fluttertoast.showToast(msg: "Sign in fail : ${error.toString()}");
              throw (Exception("Sign in fail : ${error.toString()}"));
            });
          } catch (e) {
            widget.onStateChanged(Status.authenticateError);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
              ),
            );
          }
        } else {
          widget.onStateChanged(Status.authenticateError);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Invalid login input!"),
            ),
          );
        }
      },
      child: const Text('Login'),
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignUpView(),
          ),
        );
      },
      child: const Text('Create Account'),
    );
  }
}
