import 'package:flutter/material.dart';
import 'package:lab_2/models/MealDetail.dart';
import 'package:lab_2/services/meal_api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_launcher/url_launcher.dart' show LaunchMode;

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({Key? key, required this.mealId}) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealApiService apiService = MealApiService();

  MealDetail? meal;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  Future<void> loadDetails() async {
    try {
      final result = await apiService.getMealDetails(widget.mealId);
      setState(() {
        meal = result;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading meal details: $e");
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recipe Details")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError || meal == null
          ? const Center(child: Text("Failed to load recipe"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(meal!.thumbnail),
                  ),
                  const SizedBox(height: 16),

                  // TITLE
                  Text(
                    meal!.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // INGREDIENTS
                  const Text(
                    "Ingredients",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  ...meal!.ingredients.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text("• ${entry.key} – ${entry.value}"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // INSTRUCTIONS
                  const Text(
                    "Instructions",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    meal!.instructions,
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  if (meal!.youtube.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () async {
                        final url = Uri.parse(meal!.youtube);

                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.platformDefault,
                          );
                        } else {
                          print("Could not launch URL");
                        }
                      },

                      icon: const Icon(Icons.play_circle_fill),
                      label: const Text("Watch on YouTube"),
                    ),
                ],
              ),
            ),
    );
  }
}
