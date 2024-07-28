
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:jot_spot/splashScreen.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';


 void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "JotSpot",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent, // A vibrant blue for primary actions
        scaffoldBackgroundColor: Colors.black87, // Slightly lighter dark background for better contrast
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // Deep black for a sleek look
          titleTextStyle: TextStyle(
            color: Colors.white, // White title for contrast
            fontSize: 22.0, // Slightly larger for emphasis
            fontWeight: FontWeight.bold, // Bold for better visibility
          ),
          elevation: 20, // Removes shadow for a flat design
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white, // White text for readability
          unselectedLabelColor: Colors.grey[400], // Softer gray for unselected tab labels
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w500, // Slightly heavier weight for labels
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
          ),
          indicatorColor: Colors.blueAccent, // Accent color for the tab indicator
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white, // White text for readability
            fontWeight: FontWeight.normal, // Standard weight for body text
          ),
          bodyMedium: TextStyle(
            color: Colors.white70, // Slightly lighter for less emphasis
            fontWeight: FontWeight.normal,
          ),
          titleLarge: TextStyle(
            color: Colors.white, // White title for contrast
            fontSize: 25.0, // Slightly larger for emphasis
            fontWeight: FontWeight.w600,
          ),
        ),
        primaryColorLight: Colors.tealAccent, // Bright accent color for primary actions
        iconTheme: const IconThemeData(
          color: Colors.white, // White icons for visibility
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blueAccent, // Accent color for buttons
          textTheme: ButtonTextTheme.primary, // Ensures button text is readable
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600]!), // Subtle border color
          ),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.blueAccent), // Accent color on focus
          // ),
          hintStyle: const TextStyle(
            color: Colors.white54, // Light gray hint text for better readability
          ),
          labelStyle: const TextStyle(
            color: Colors.white, // White label text for input fields
          ),
        ),
      ),
        home: const Splash(),
    );
  }
}