import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipes_dummy_api/models/login_response.dart';
import 'package:recipes_dummy_api/screens/all_recipe.dart';
import 'package:recipes_dummy_api/screens/splash.dart';
import 'package:recipes_dummy_api/widgets/uihelper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController uNameController = TextEditingController();
  TextEditingController pswdController = TextEditingController();

  LoginResponse? details;
  bool isLoading = false;

  @override
  void initState() {
    postDataAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LogIn"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 62, 1, 57),
                    Color.fromARGB(255, 66, 1, 78),
                    Color.fromARGB(255, 62, 1, 57),
                    Color.fromARGB(255, 15, 1, 40),
                    Color.fromARGB(255, 66, 1, 78),
                    Color.fromARGB(255, 62, 1, 57),
                    Color.fromARGB(255, 15, 1, 40),
                    Color.fromARGB(255, 66, 1, 78),
                    Color.fromARGB(255, 62, 1, 57),
                    Color.fromARGB(255, 66, 1, 78),
                    Color.fromARGB(255, 16, 2, 41),
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Uihelper.customTextFormField(
                          uNameController, Icons.person, "Username"),
                      const SizedBox(
                        height: 25,
                      ),
                      Uihelper.customTextFormField(
                          pswdController, Icons.lock, "Password"),
                      const SizedBox(
                        height: 25,
                      ),
                      Uihelper.customElevatedButton(() {
                        FocusScope.of(context).unfocus();
                        if (uNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Please enter valid username")));
                        } else if (pswdController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Please enter valid password")));
                        } else {
                          postDataAuth();
                        }
                      }, "Login")
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  postDataAuth() async {
    isLoading = true;
    _notify();
          // For login: check username: emilys & password: emilyspass
    var uri = Uri.parse("https://dummyjson.com/auth/login");
    var requestData = {
      "username": uNameController.text,
      "password": pswdController.text,
      "expiresInMins": "30"
    };

    var response = await http.post(uri, body: requestData);
    details = LoginResponse.fromJson(jsonDecode(response.body));

    isLoading = false;
    _notify();

    try {
      if (response.statusCode == 200) {
        var sharedPreference = await SharedPreferences.getInstance();
        sharedPreference.setString(SplashScreenState.KEYLOGIN, uNameController.text);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Login is successful")));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return AllRecipe(
                uName: details!.firstName!,
              );
            },
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }

    _notify();
  }

  _notify() {
    if (mounted) {
      setState(() {});
    }
  }
}
