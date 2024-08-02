import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recipes_dummy_api/screens/all_recipe.dart';
import 'package:recipes_dummy_api/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static String KEYLOGIN = "Amisha";

  @override
  void initState() {
    whereToGo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: SweepGradient(
            colors: [
              Color.fromARGB(255, 94, 1, 1),
              Color.fromARGB(255, 95, 43, 0),
              Color.fromARGB(255, 40, 1, 94),
              Color.fromARGB(255, 82, 64, 1),
              Color.fromARGB(255, 21, 1, 80),
              Color.fromARGB(255, 94, 1, 1),
              Color.fromARGB(255, 1, 71, 85),
              Color.fromARGB(255, 1, 94, 17),
              Color.fromARGB(255, 94, 1, 1),
              Color.fromARGB(255, 21, 1, 80),
              Color.fromARGB(255, 94, 1, 1),
              Color.fromARGB(255, 1, 71, 85),
              Color.fromARGB(255, 1, 94, 17),
              Color.fromARGB(255, 82, 64, 1),
              Color.fromARGB(255, 21, 1, 80),
              Color.fromARGB(255, 94, 1, 1),
              Color.fromARGB(255, 1, 71, 85),
              Color.fromARGB(255, 1, 94, 17),
              Color.fromARGB(255, 21, 1, 80),
              Color.fromARGB(255, 94, 1, 1),
              Color.fromARGB(255, 1, 71, 85),
              Color.fromARGB(255, 1, 94, 17),
            ],
          ),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon( 
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
              Text(
                "Welcome",
                style: TextStyle(fontSize: 30, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  void whereToGo() async {
    var sharedPreference = await SharedPreferences.getInstance();
    var uName = sharedPreference.getString(KEYLOGIN);

    Timer(const Duration(seconds: 2), (){
          if (uName == null || uName.isEmpty) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
              return const LogIn();
            }));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
              return  AllRecipe(uName: uName,);
            }));
          }
    });
  }
}
