import 'Widget.dart';
import 'package:flutter/material.dart';

enum ApplicationLoginState {
  loggedOut,
  emailAddress,
  register,
  password,
  loggedIn,
}
class Authentication extends StatelessWidget {
      const Authentication({
        required this.loginState,
        required this.email,
        required this.startLoginFlow,
        required this.verifyEmail,
        required this.signInWithEmailAndPassword,
        required this.cancleRegistration,
        required this.registerAccount,
        required this.signOut,
    });
  final ApplicationLoginState loginState;
  final String? email;
  final void Function() startLoginFlow;
  final void Function(
        String email,
        void Function(Exception e) error,
      )verifyEmail;
  final void Function(
      String email,
      String password,
      void Function(Exception e) error,
      )signInWithEmailAndPassword;
  final void Function()cancleRegistration;
  final void Function(
      String email,
      String displayName,
      String password,
      void Function(Exception e) error,
      )registerAccount;
  final void Function()signOut;

  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case ApplicationLoginState.loggedOut:
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                  child: Text('SIGN IN TO RSVP'),
                  onPressed: () {
                    startLoginFlow();
                  }),
            ),
          ],
        );
      case ApplicationLoginState.emailAddress:
        return EmailForm(
            callback: (email) =>
                verifyEmail(
                    email,
                        (e) => _showErrorDialog(context, 'Invalied Email', e)
                )
        );
      case ApplicationLoginState.password:
        return PasswordForm(
            email: email!,
            login: (email, password) =>
                signInWithEmailAndPassword(
                    email, password,
                        (e) => _showErrorDialog(context, 'Field to Sign-in', e)
                )
        );
      case ApplicationLoginState.register:
        return RegisterForm(
          email: email!,
          cancle: () {
            cancleRegistration();
          },
          registerAccount: (email,
              displayName,
              password,) {
            registerAccount(
                email,
                displayName,
                password,
                    (e) =>
                    _showErrorDialog(context, 'Field to Create Account', e)
            );
          },
        );
      case ApplicationLoginState.loggedIn:
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                  child: Text('LOGOUT'),
                  onPressed: () {
                    signOut();
                  }),
            ),
          ],
        );
      default:
        return Row(
          children: const [
            Text("Internel Error , It shoulden't happen....."),
          ],
        );
    }
  }
  void _showErrorDialog(BuildContext context,String title,Exception e){
    showDialog<void>(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              title: Text(
                title,
                style: TextStyle(fontSize: 24),
              ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                      '${(e as dynamic).message}',
                    style: TextStyle(fontSize:18),
                  ),
                ],
              ),
            ),
            actions: [
              StyledButton(
                  child: const Text(
                    'OK',
                    style:TextStyle(color: Colors.deepPurple),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  }
              )
            ],
          );
        }
    );
  }
}
class EmailForm extends StatefulWidget {
 const EmailForm({required this.callback});
 final void Function(String email) callback;
  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formkey = GlobalKey<FormState>(debugLabel: '_EmailFormState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header('Sign In With Email'),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child:TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter Your Email',
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter your Email Address To Continue...';
                        }
                        return null;
                      },
                    ) ,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 16
                      ),
                        child: StyledButton(
                          onPressed: ()async{
                            if(_formkey.currentState!.validate()){
                              widget.callback(_controller.text);
                            }
                          },
                          child: Text('NEXT'),
                        ),
                      )
                    ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class RegisterForm extends StatefulWidget {
  RegisterForm({
    required this.registerAccount,
    required this.cancle,
    required this.email,
  });
  final String email;
  final void Function(String email,String displayName,String password) registerAccount;
  final void Function() cancle;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formkey = GlobalKey<FormState>(debugLabel: '_RegisterFormState');
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
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
            key: _formkey,
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: widget.cancle,
                        child: const Text('CANCEL'),
                      ),
                      const SizedBox(width: 16),
                      StyledButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            widget.registerAccount(
                              _emailController.text,
                              _displayNameController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        child: const Text('SAVE'),
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
      children: [
        const Header('Sign in'),
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 16),
                      StyledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        child: const Text('SIGN IN'),
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


