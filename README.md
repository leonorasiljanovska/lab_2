# 🍽️ Flutter Meals App — Lab 2

A simple Flutter recipe browser using **TheMealDB API**, created as part of **Lab 2 for Mobile Information Systems**.  
The app demonstrates API integration, navigation, models, UI widgets, and asynchronous data handling.

---

## 🚀 Features

### ✔ **1. Categories Screen**
- Fetches all meal categories:  
  https://www.themealdb.com/api/json/v1/1/categories.php  
- Displays categories as cards (image + name + short description)  
- Clicking a category opens all meals from that category  
- Includes a **“Get Random Recipe”** button in the AppBar  

---

### ✔ **2. Meals From Category**
- Fetches meals from selected category:  
  https://www.themealdb.com/api/json/v1/1/filter.php?c={category}  
- Displays meals in a grid layout  
- Includes search functionality for filtering meals  

---

### ✔ **3. Meal Details Screen**
- Fetches full meal details by ID:  
  https://www.themealdb.com/api/json/v1/1/lookup.php?i={id}  
- Shows:
  - Meal image  
  - Name  
  - Instructions  
  - Ingredients + measures  
  - YouTube tutorial link (if available)

---

### ✔ **4. Random Meal Feature**
- Loads a completely random recipe using:  
  https://www.themealdb.com/api/json/v1/1/random.php  
- Opens the recipe details screen directly

---

## 🧩 Project Architecture
```
lib/
│
├── models/
│ ├── Meal.dart
│ ├── MealCategory.dart
│ └── MealDetail.dart
│
├── services/
│ └── meal_api_service.dart
│
├── screens/
│ ├── category_list_screen.dart
│ ├── meals_from_category_screen.dart
│ └── recipe_details_screen.dart
│
└── main.dart
```
- **models/** → Data structures mapped from API responses  
- **services/** → API calls using the http package  
- **screens/** → UI pages with navigation  
- **main.dart** → App entry point  

---

## 🛠️ Technologies Used

- Flutter  
- Dart  
- HTTP package  
- url_launcher  
- Material UI  
- TheMealDB API  

---

## ▶️ Running the App

Install dependencies:

```sh
flutter pub get
Run the app:

flutter run

📌 Notes
- YouTube links may not work on some Android emulators due to intent restrictions.
  They work normally on physical devices.

- The app uses async API calls and StatefulWidgets for loading states.
