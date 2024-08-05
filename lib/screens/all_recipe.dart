import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipes_dummy_api/models/all_recipes_response.dart';
import 'package:recipes_dummy_api/screens/login.dart';
import 'package:recipes_dummy_api/screens/single_recipes_screen.dart';
import 'package:recipes_dummy_api/screens/splash.dart';
import 'package:recipes_dummy_api/widgets/uihelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AllRecipe extends StatefulWidget {
  const AllRecipe({super.key, required this.uName});
  final String uName;

  @override
  State<AllRecipe> createState() => _AllRecipeState();
}

class _AllRecipeState extends State<AllRecipe> {
  AllRecipesResponse? details, searchRecipeDetails;
  List<Recipes> recipesList = [];

  TextEditingController searchTextController = TextEditingController();
  bool isSearch = false;
  Timer? debounce;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllRecipes();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchTextController.dispose();
    if (debounce != null) {
      debounce!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${widget.uName}"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 70, 2, 82),
        actions: [
          IconButton(
            tooltip: "Logout",
            onPressed: () async {
              var sharedPreference = await SharedPreferences.getInstance();
              sharedPreference.remove(SplashScreenState.KEYLOGIN);
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return const LogIn();
              }));
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(183, 231, 185, 239),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: searchTextController,
                          onChanged: (value) {
                            isSearch = value.isNotEmpty;
                            _notify();

                            if (debounce?.isActive ?? false) debounce!.cancel();

                            debounce =
                                Timer(const Duration(milliseconds: 5000), () {
                              getSearchRecipe(value);
                            });
                            _notify();
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            hintText: "Search Recipes",
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: isSearch
                                ? GestureDetector(
                                    onTap: () {
                                      searchTextController.clear();
                                      isSearch = false;
                                      _notify();
                                      getAllRecipes();
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 20,
                                    ),
                                  )
                                : const SizedBox(
                                    width: 0,
                                    height: 0,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.6,
                              crossAxisCount: 2,
                            ),
                            itemCount: recipesList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Uihelper.customCard(
                                  recipesList[index].image!,
                                  recipesList[index].name!,
                                  recipesList[index].cuisine!, () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return SingleRecipesScreen(
                                      id: recipesList[index].id!);
                                }));
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  getAllRecipes() async {
    //Get all recipes: https://dummyjson.com/recipes

    isLoading = true;
    _notify();
    var uri = Uri.parse("https://dummyjson.com/recipes");
    recipesList.clear();

    try {
      var response = await http.get(uri);

      details = AllRecipesResponse.fromJson(jsonDecode(response.body));
      isLoading = false;
      _notify();
      if (response.statusCode == 200) {
        if (details != null) {
          if (details!.recipes!.isNotEmpty) {
            recipesList = details!.recipes!;
            _notify();
          }
        }
      }
    } catch (e) {
      print("$e");
    }
  }

  getSearchRecipe(String text) async {
    //search recipe
    //https://dummyjson.com/recipes/search?q=Margherita

    isLoading = true;
    _notify();

    recipesList.clear();
    var uri = Uri.parse("https://dummyjson.com/recipes/search")
        .replace(queryParameters: {"q": text});

    try {
      var response = await http.get(uri);
      searchRecipeDetails =
          AllRecipesResponse.fromJson(jsonDecode(response.body));
      isLoading = false;
      _notify();

      if (searchRecipeDetails != null) {
        if (searchRecipeDetails!.recipes!.isNotEmpty) {
          recipesList = searchRecipeDetails!.recipes!;
        }
      }
      _notify();
    } catch (e) {
      print("$e");
    }
  }

  _notify() {
    if (mounted) {
      setState(() {});
    }
  }
}
