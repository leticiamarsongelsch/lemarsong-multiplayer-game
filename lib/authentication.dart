import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiplayer_game/game_screen.dart';
import 'package:multiplayer_game/profile_screen.dart';
import 'package:multiplayer_game/user.dart';

import 'widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ApplicationLoginState {
  loggedOut,
  emailAddress,
  register,
  password,
  loggedIn,
}

class Authentication extends StatelessWidget {
  final int kDefaultPadding = 20;

  const Authentication({
    required this.loginState,
    required this.email,
    required this.startLoginFlow,
    required this.verifyEmail,
    required this.signInWithEmailAndPassword,
    required this.cancelRegistration,
    required this.registerAccount,
    required this.signOut,
  });

  final ApplicationLoginState loginState;
  final String? email;
  final void Function() startLoginFlow;
  final void Function(
    String email,
    void Function(Exception e) error,
  ) verifyEmail;
  final void Function(
    String email,
    String password,
    void Function(Exception e) error,
  ) signInWithEmailAndPassword;
  final void Function() cancelRegistration;
  final void Function(
    String email,
    String displayName,
    String password,
    void Function(Exception e) error,
  ) registerAccount;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case ApplicationLoginState.loggedOut:
        return Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
              //padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.blue, backgroundColor: Colors.blue),
                onPressed: () {
                  startLoginFlow();
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Sign In',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          ],
        );
      case ApplicationLoginState.emailAddress:
        return EmailForm(
            callback: (email) => verifyEmail(
                email, (e) => _showErrorDialog(context, 'Invalid email', e)));
      case ApplicationLoginState.password:
        return PasswordForm(
          email: email!,
          login: (email, password) {
            signInWithEmailAndPassword(email, password,
                (e) => _showErrorDialog(context, 'Failed to sign in', e));
          },
        );
      case ApplicationLoginState.register:
        return RegisterForm(
          email: email!,
          cancel: () {
            cancelRegistration();
          },
          registerAccount: (
            email,
            displayName,
            password,
          ) {
            registerAccount(
                email,
                displayName,
                password,
                (e) =>
                    _showErrorDialog(context, 'Failed to create account', e));
          },
        );
      case ApplicationLoginState.loggedIn:
        return Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    //padding: const EdgeInsets.only(left: 24, bottom: 8),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.blue, backgroundColor: Colors.blue),
                      onPressed: () {
                        signOut();
                        //_openDashboard(context);
                      },
                      child: Text('LOGOUT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.all(20),
                    child:
                    Text(
                      "Cool, now you're logged... press the button below to go to your profile screen"
                          " and be able to play the game.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 10, color: Colors.blue),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5);
                                }
                                return Colors.lightBlue; //Theme.of(context).colorScheme.onSecondary.withOpacity(0.5);
                              }),
                            ),
                            onPressed: (){
                              _setValuesUserLogged();
                              _openProfileScreen(context);
                            },
                            //-----------------------ABRIR O JOGO!
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "START GAME",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(color: Colors.white), //color
                              ),
                            ),
                          ))),
                ],
              ),
            ],
          ),
        );
      default:
        return Row(
          children: [
            Text("Internal error",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .headline6!
                      .color!
                      .withOpacity(0.80),
                )),
          ],
        );
    }
  }

  _openProfileScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
  }

  void _setValuesUserLogged() {
    UserLoggedIn _userLogged = UserLoggedIn();
    _userLogged.userEmail = FirebaseAuth.instance.currentUser!.email.toString();
    _userLogged.userName =
        FirebaseAuth.instance.currentUser!.displayName.toString();
    _userLogged.userId = FirebaseAuth.instance.currentUser!.uid.toString();
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.all(10),
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.blue, backgroundColor: Colors.blue),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            /*StyledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),*/
          ],
        );
      },
    );
  }
}

class EmailForm extends StatefulWidget {
  const EmailForm({required this.callback});

  final void Function(String email) callback;

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_EmailFormState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header('Sign in with email'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your email address to continue';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child:
                          //StyledButton(
                          TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.blue, backgroundColor: Colors.blue),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            widget.callback(_controller.text);
                          }
                        },
                        child: Text(
                          'NEXT',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    required this.registerAccount,
    required this.cancel,
    required this.email,
  });

  final String email;
  final void Function(String email, String displayName, String password)
      registerAccount;
  final void Function() cancel;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_RegisterFormState');
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _groupController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header('Create account'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your email address to continue';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      hintText: 'First & last name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your account name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _groupController,
                    decoration: const InputDecoration(
                      hintText: 'Group',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your group name (по-91б/по-92б)';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: widget.cancel,
                        child: const Text('CANCEL'),
                      ),
                      const SizedBox(width: 16),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              primary: Colors.blue,
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              widget.registerAccount(
                                _emailController.text,
                                _displayNameController.text,
                                _passwordController.text,
                              );
                              //PRA ADICIONAR NO BD UM NODE PRO USUÁRIO ESPECÍFICO------------
                              UserLoggedIn().userTeamColor="green";
                              UserLoggedIn().userGroup = _groupController.text;
                              UserLoggedIn().userFirstTimeRegister ="true";
                              UserLoggedIn().userEmail = _emailController.text;
                              UserLoggedIn().userName = _displayNameController.text;
                            }
                          },
                          child: const Text('SAVE',
                          style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PasswordForm extends StatefulWidget {
  const PasswordForm({
    required this.login,
    required this.email,
  });

  final String email;
  final void Function(String email, String password) login;

  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PasswordFormState');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Header('Sign in'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your email address to continue';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 16),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child:
                      TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.blue, backgroundColor: Colors.blue),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        child: Text('SIGN IN',
                        style: TextStyle(color: Colors.white),),
                      ),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
