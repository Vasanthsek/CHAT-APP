import 'dart:io';


import 'package:cool_chat_app/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class Authform extends StatefulWidget {
  final bool isLoading;
  final void Function(String email, String password, String username, File? imagee,
      bool isLogin, BuildContext ctx) submitFn;
  const Authform({Key? key, required this.submitFn, required this.isLoading})
      : super(key: key);

  @override
  State<Authform> createState() => _AuthformState();
}

class _AuthformState extends State<Authform> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userName = "";
  var _userEmail = "";
  var _userPassword = "";
  File? _userImageFile;

  void _pickeddImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState!.validate();
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text("Please pick an image"),
            backgroundColor: Theme.of(context).errorColor),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),_userImageFile,
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(imagePickFn: _pickeddImage),
                TextFormField(
                    key: const ValueKey("Email Address"),
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(labelText: 'Email Address')),
                if (!_isLogin)
                  TextFormField(
                      key: const ValueKey("Username"),
                      onSaved: (newValue) {
                        _userName = newValue!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a valid username";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Username')),
                TextFormField(
                    key: const ValueKey("Password"),
                    onSaved: (newValue) {
                      _userPassword = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return "Please enter more that six characters";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password')),
                const SizedBox(
                  height: 12,
                ),
                if (widget.isLoading) const CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    onPressed: () {
                      _trySubmit();
                    },
                    child: Text(_isLogin ? "Login" : "Signup"),
                  ),
                if (!widget.isLoading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    style: TextButton.styleFrom(primary: Colors.pink),
                    child: Text(_isLogin ? "Create a new account" : "Login"),
                  )
              ],
            )),
      )),
    ));
  }
}
