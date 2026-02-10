import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/auth_provider.dart';
import 'package:law_library/utils/validators.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final uiDensity = themeProvider.uiDensity;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loginAppBarTitle),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(
                AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ).animate().scale(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                  ),

                  SizedBox(
                      height: AppTheme.getSpacing(
                          AppTheme.baseSpacing24, uiDensity)),

                  Text(
                    l10n.loginWelcomeTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 300),
                  ),

                  SizedBox(
                      height: AppTheme.getSpacing(
                          AppTheme.baseSpacing8, uiDensity)),

                  Text(
                    l10n.loginSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 400),
                  ),

                  SizedBox(
                      height: AppTheme.getSpacing(
                          AppTheme.baseSpacing32, uiDensity)),

                  // Username field
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: l10n.loginUsernameLabel,
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) => Validators.validateUsername(value, context),
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                  ).animate().fadeIn(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 500),
                  ).moveY(begin: 10, end: 0),

                  SizedBox(
                      height: AppTheme.getSpacing(
                          AppTheme.baseSpacing16, uiDensity)),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: l10n.loginPasswordLabel,
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) => Validators.validatePassword(value, context),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _login(),
                  ).animate().fadeIn(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 600),
                  ).moveY(begin: 10, end: 0),

                  // Error message
                  if (authProvider.error != null) ...[
                    SizedBox(
                        height: AppTheme.getSpacing(
                            AppTheme.baseSpacing16, uiDensity)),
                    Container(
                      padding: EdgeInsets.all(AppTheme.getSpacing(
                          AppTheme.baseSpacing12, uiDensity)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(AppTheme.getSpacing(
                            AppTheme.borderRadiusMedium, uiDensity)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          SizedBox(
                              width: AppTheme.getSpacing(
                                  AppTheme.baseSpacing8, uiDensity)),
                          Expanded(
                            child: Text(
                              authProvider.error!, // optional: replace with l10n.loginErrorGeneric
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(
                      duration: const Duration(milliseconds: 400),
                    ).shake(),
                  ],

                  SizedBox(
                      height: AppTheme.getSpacing(
                          AppTheme.baseSpacing24, uiDensity)),

                  // Login button
                  ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: AppTheme.getSpacing(
                              AppTheme.baseSpacing16, uiDensity)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.getSpacing(
                            AppTheme.borderRadiusMedium, uiDensity)),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      l10n.loginButton,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ).animate().fadeIn(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 700),
                  ).moveY(begin: 10, end: 0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
