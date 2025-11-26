import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab_2/models/Meal.dart';
import 'package:lab_2/models/MealCategory.dart';
import 'package:lab_2/models/MealDetail.dart';

class MealApiService {
  final String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<List<MealCategory>> getCategories() async {
    final url = Uri.parse('$baseUrl/categories.php');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to load categories!");
    }
    final data = jsonDecode(response.body);
    final List categoriesJSON = data["categories"];

    return categoriesJSON.map((json) => MealCategory.fromJson(json)).toList();
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    final url = Uri.parse('$baseUrl/filter.php?c=$category');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to get meals from category: $category");
    }
    final data = jsonDecode(response.body);
    final List mealsFromCategoryJSON = data["meals"];

    return mealsFromCategoryJSON.map((json) => Meal.fromJson(json)).toList();
  }

  Future<MealDetail> getMealDetails(String id) async {
    final url = Uri.parse('$baseUrl/lookup.php?i=$id');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to load meal details");
    }
    final data = jsonDecode(response.body);
    final detailsJSON = data["meals"][0];

    return MealDetail.fromJson(detailsJSON);
  }
  
  Future<MealDetail> getRandomMeal() async {
    final url=Uri.parse('$baseUrl//random.php');
    final response = await http.get(url);

    if(response.statusCode!=200){
      throw Exception("Failed to load random meal");
    }
    final data=jsonDecode(response.body);
    final detailsJSON = data["meals"][0];

    return MealDetail.fromJson(detailsJSON);
  }
}
