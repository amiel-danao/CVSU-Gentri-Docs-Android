import 'package:auth_service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../api/student_controller.dart';
import '../../constants/app_constants.dart';
import '../../constants/color_constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/profile_widgets.dart';

class SignUpView extends StatefulWidget {
  SignUpView({Key? key}) : super(key: key);

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUpView> {
  final TextEditingController _emailController =
      TextEditingController(text: "amiel.tbpo@gmail.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "notCommonPassword123\$");
  final TextEditingController _confirmPasswordController =
      TextEditingController(text: "notCommonPassword123\$");
  final TextEditingController _firstNameController =
      TextEditingController(text: "amiel");
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController =
      TextEditingController(text: "danao");

  final _formKey = GlobalKey<FormState>();
  Status _status = Status.uninitialized;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Create Account'),
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
        Center(
            child: SingleChildScrollView(
          child: DecoratedBox(
            decoration:
                const BoxDecoration(color: Color.fromARGB(211, 252, 252, 252)),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ProfileAccountName(
                        controller: _firstNameController,
                        placeHolder: 'First name',
                        textValidator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length == 0)
                            return "Please input First name";
                          else
                            return null;
                        },
                      ),
                      ProfileAccountName(
                        controller: _middleNameController,
                        placeHolder: 'Middle name',
                      ),
                      ProfileAccountName(
                        controller: _lastNameController,
                        placeHolder: 'Last name',
                        textValidator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length == 0)
                            return "Please input Last name";
                          else
                            return null;
                        },
                      ),
                      ProfileAccountEmail(emailController: _emailController),
                      ProfileAccountPassword(
                          passwordController: _passwordController,
                          otherPasswordController: _confirmPasswordController,
                          label: "Password"),
                      ProfileAccountPassword(
                          passwordController: _confirmPasswordController,
                          otherPasswordController: _passwordController,
                          label: "Confirm Password"),
                      const SizedBox(height: 30.0),
                      _SubmitButton(
                          formKey: _formKey,
                          firstName: _firstNameController,
                          middleName: _middleNameController,
                          lastName: _lastNameController,
                          email: _emailController,
                          password: _passwordController,
                          onStateChanged: (status) => setState(() {
                                _status = status;
                              })),
                    ],
                  ),
                )),
          ),
        )),
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
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class _SubmitButton extends StatelessWidget {
  _SubmitButton(
      {Key? key,
      required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.onStateChanged,
      required this.formKey})
      : super(key: key);

  final formKey;
  final AuthStateCallback onStateChanged;
  final TextEditingController firstName, middleName, lastName, email, password;
  final AuthService _authService = FirebaseAuthService(
    authService: FirebaseAuth.instance,
  );

  void _submit(BuildContext context) async {
    final isValid = formKey.currentState.validate();
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid input!"),
        ),
      );
      return;
    }

    formKey.currentState.save();

    try {
      onStateChanged(Status.authenticating);
      await _authService
          .createUserWithEmailAndPassword(
        firstName: firstName.text,
        middleName: middleName.text,
        lastName: lastName.text,
        email: email.text,
        password: password.text,
      )
          .then((value) async {
        await createUserProfileIfNotExist(value, context)
            .then((value) {})
            .catchError((error) {
          onStateChanged(Status.authenticateError);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
            ),
          );
        });
      }).catchError((error) {
        onStateChanged(Status.authenticateError);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration fail:${error.toString()}"),
          ),
        );
      });
    } catch (e) {
      onStateChanged(Status.authenticateError);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.themeColor,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      onPressed: () => _submit(context),
      child: const Text('Create Account'),
    );
  }
}
