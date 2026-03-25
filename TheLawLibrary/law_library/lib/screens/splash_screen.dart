import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:law_library/providers/auth_provider.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/screens/home_screen.dart';
import 'package:law_library/screens/onboarding_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:law_library/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final lawProvider = Provider.of<LawProvider>(context, listen: false);

    try {
      await authProvider.initializeAuth();
      await lawProvider.fetchCategories();
      await lawProvider.loadFavorites();
    } catch (_) {}

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final onboardingShown = prefs.getBool('onboarding_shown_v1') ?? false;

    if (!mounted) return;

    final nextScreen =
    onboardingShown ? const HomeScreen() : const OnboardingScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => nextScreen,
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Centred logo + title ─────────────────────────────
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/logo.png',
                    width: 96,
                    height: 96,
                  )
                      .animate()
                      .scale(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                    begin: const Offset(0.2, 0.2),
                    end: const Offset(1.0, 1.0),
                  )
                      .fadeIn(duration: const Duration(milliseconds: 400)),

                  const SizedBox(height: 24),

                  // App name
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate()
                      .fadeIn(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 300),
                  )
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 6),

                  // Subtitle
                  Text(
                    l10n.splashSubtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      letterSpacing: 0.3,
                    ),
                  )
                      .animate()
                      .fadeIn(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 450),
                  ),
                ],
              ),
            ),

            // ── Loading spinner + version at bottom ──────────────
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      .animate()
                      .fadeIn(
                    duration: const Duration(milliseconds: 400),
                    delay: const Duration(milliseconds: 600),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'v1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                      fontSize: 11,
                    ),
                  )
                      .animate()
                      .fadeIn(
                    duration: const Duration(milliseconds: 400),
                    delay: const Duration(milliseconds: 700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}