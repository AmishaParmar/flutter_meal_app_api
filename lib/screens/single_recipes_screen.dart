import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipes_dummy_api/models/all_recipes_response.dart';

class SingleRecipesScreen extends StatefulWidget {
  const SingleRecipesScreen({super.key, required this.id});
  final int id;

  @override
  State<SingleRecipesScreen> createState() => _SingleRecipesScreenState();
}

class _SingleRecipesScreenState extends State<SingleRecipesScreen> {
  Recipes? singleRecipe;
  bool isLoading = false;
  List<String> ingredientsUsed = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSingleRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Single recipe screen"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 70, 2, 82),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(183, 231, 185, 239),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                        child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(183, 68, 8, 81),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "Name: ${singleRecipe!.name}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                    singleRecipe!.image.toString())),
                            const SizedBox(height: 16),
                            Text(
                              "Cuisine: ${singleRecipe!.cuisine.toString()}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Preparation time: ${singleRecipe!.prepTimeMinutes.toString()}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Cooking Time: ${singleRecipe!.cookTimeMinutes.toString()}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Serving: ${singleRecipe!.servings.toString()}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Ratings: ${singleRecipe!.rating.toString()}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Divider(
                              height: 5,
                            ),
                            const Text(
                              "Ingredients Used:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            ...singleRecipe!.ingredients!.map((ingredient) {
                              return Text(
                                "- $ingredient",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              );
                            }),
                            const Divider(
                              height: 5,
                            ),
                            const Text(
                              "Instructions:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            ...singleRecipe!.instructions!
                                .map((recipeInstructions) {
                              return Text(
                                "- $recipeInstructions",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              );
                            }),
                            const Divider(
                              height: 5,
                            ),
                            const Text(
                              "Tags:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            ...singleRecipe!.tags!.map((tag) {
                              return Text("- $tag",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),);
                            }),
                            const Divider(
                              height: 5,
                            ),
                            const Text(
                              "Meal Type:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            ...singleRecipe!.mealType!.map((typeOfMeal) {
                              return Text("- $typeOfMeal",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),);
                            }),
                          ],
                        ),
                      ),
                    )),
                  ),
                ),
              ),
            ),
    );
  }

  getSingleRecipe() async {
    isLoading = true;
    _notify();
    // get a single recipe: 'https://dummyjson.com/recipes/1'
    var url = Uri.parse("https://dummyjson.com/recipes/" + "${widget.id}");

    try {
      var response = await http.get(url);
      singleRecipe = Recipes.fromJson(jsonDecode(response.body));

      isLoading = false;
      _notify();
      if (singleRecipe != null) {
        ingredientsUsed = singleRecipe!.ingredients!;
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }

  _notify() {
    if (mounted) {
      setState(() {});
    }
  }
}
