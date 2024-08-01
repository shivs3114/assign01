import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int userid = 0;
  bool isLogin = false;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String passwd = '';
  String username = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          title: isLogin
              ? Center(child: Text('L O G I N'))
              : Center(child: Text('S I G N U P')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !isLogin
                      ? TextFormField(
                          key: ValueKey('username'),
                          validator: (value) {
                            if (value.toString().length < 4) {
                              return "Username is small";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            setState(() {
                              username = value!;
                            });
                          },
                          decoration:
                              InputDecoration(hintText: 'Enter username'),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (!value.toString().contains('@') || value!.isEmpty) {
                        return "Email is not valid";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        email = value!;
                      });
                    },
                    decoration: InputDecoration(hintText: 'Enter email'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.toString().length < 6) {
                        return 'password is too small';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        passwd = value!;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.purpleAccent,
                    child: ElevatedButton(
                        style: ButtonStyle(),
                        onPressed: () {
                          setState(() {});
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            print('happy');
                            /*isLogin
                                ? SignIn(email, passwd)
                                : SignUp(email, passwd);
                            Navigator.pop(context);
                            if (!isLogin) {
                              FirebaseFirestore.instance
                                  .collection('travel')
                                  .doc('user')
                                  .set({
                                'userId': {
                                  'id': userid,
                                  'username': username,
                                  'email': email
                                }
                              }, SetOptions(merge: true));
                            }*/
                            final snackbar = SnackBar(
                                content: isLogin
                                    ? Text('Logged In')
                                    : Text('Signed In'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          }
                        },
                        child: isLogin
                            ? Text(' L O G I N ')
                            : Text('S I G N  U P')),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: isLogin
                          ? Text('Dont have an account? Sign up')
                          : Text('Already have an Account? LOGIN'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
