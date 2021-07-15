import 'package:flutter/material.dart';

import 'package:tech_demo/services/authservice.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.auth}) : super(key: key);
  final AuthService auth;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool passwordHidden = true;

  Color greenColor = Color(0xFF00AF19);

  //To check fields during submit
  checkFields() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _enterpass(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            style: TextStyle(
              color: Colors.black,
            ),
            controller: _password,
            obscureText: passwordHidden,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(
                  passwordHidden ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    passwordHidden = !passwordHidden;
                  });
                },
              ),
              errorStyle: TextStyle(
                color: Colors.black,
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Password can\'t be empty';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget _enteremail(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            style: TextStyle(
              color: Colors.black,
            ),
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            decoration: InputDecoration(
              errorStyle: TextStyle(
                color: Colors.black,
              ),
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regex = new RegExp(pattern);
              if (value!.isEmpty) {
                return 'Email can\'t be empty';
              } else if (!regex.hasMatch(value)) return 'Enter Valid Email';
              return null;
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(key: formKey, child: _buildLoginForm())));
  }

  _buildLoginForm() {
    return Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: ListView(children: [
          SizedBox(height: 75.0),
          _enteremail("Email id"),
          _enterpass("Password"),
          SizedBox(height: 5.0),
          SizedBox(height: 50.0),
          GestureDetector(
            onTap: () {
              print(checkFields());
              if (checkFields())
                widget.auth.signIn(_email.text, _password.text, context);
            },
            child: Container(
                height: 50.0,
                child: Material(
                    borderRadius: BorderRadius.circular(25.0),
                    shadowColor: Colors.greenAccent,
                    color: greenColor,
                    elevation: 7.0,
                    child: Center(
                        child: Text('LOGIN',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Trueno'))))),
          ),
        ]));
  }
}
