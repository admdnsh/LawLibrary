import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/auth_provider.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/screens/home_screen.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Initialize providers
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final lawProvider = Provider.of<LawProvider>(context, listen: false);
    
    try {
      // Initialize auth first (check if user is already logged in)
      await authProvider.initializeAuth();
      
      // Initialize laws data
      await lawProvider.initialize();
    } catch (e) {
      // If there's an error, we'll still continue to the home screen
      // The error will be handled in the respective providers
    }
    
    // Ensure splash screen shows for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to home screen
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon/logo
            Icon(
              Icons.balance,
              size: 80,
              color: AppTheme.primaryColor,
            )
            .animate()
            .scale(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              begin: const Offset(0.2, 0.2),
              end: const Offset(1.0, 1.0),
            ),
            
            const SizedBox(height: 24),
            
            // App name
            Text(
              'Law Library',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fadeIn(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 300),
            ),
            
            const SizedBox(height: 48),
            
            // Loading indicator
            if (_isLoading)
              const CircularProgressIndicator()
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 600),
              ),
          ],
        ),
      ),
    );
  }
}