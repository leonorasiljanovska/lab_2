import 'package:flutter/material.dart';
import 'package:lab_2/models/Meal.dart';
import 'package:lab_2/screens/recipe_details_screen.dart';
import 'package:lab_2/services/meal_api_service.dart';

class MealsFromCategoryScreen extends StatefulWidget {
  final String categoryName;

  const MealsFromCategoryScreen({Key? key, required this.categoryName})
      : super(key: key);

  @override
  State<MealsFromCategoryScreen> createState() => _MealsFromCategoryScreenState();
}

class _MealsFromCategoryScreenState extends State<MealsFromCategoryScreen> {
  final MealApiService apiService = MealApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Meal> allMeals = [];
  List<Meal> filteredMeals = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    loadMeals();

    _searchController.addListener(() {
      _filterMeals(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadMeals() async {
    try {
      final result = await apiService.getMealsByCategory(widget.categoryName);
      setState(() {
        allMeals = result;
        filteredMeals = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void _filterMeals(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredMeals = allMeals;
      });
      return;
    }

    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredMeals = allMeals
          .where((meal) => meal.name.toLowerCase().contains(lowerQuery))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
          ? const Center(child: Text("Error loading meals"))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search meals...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredMeals.length,
              itemBuilder: (context, index) {
                final meal = filteredMeals[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealDetailScreen(mealId: meal.id),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            meal.thumbnail,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            meal.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
