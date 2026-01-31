import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/glass_button.dart';
import '../../../shared/widgets/glass_card.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      AuthLoginRequested(
        email: _emailController.text.trim(),
        password: _passController.text,
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.required;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.invalidFormat;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 460),
      child: GlassCard(
        padding: const .all(32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ).createShader(bounds),
                child: Text(
                  l10n.loginTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: .bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.loginSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: l10n.email,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface.withValues(alpha: 0.5),
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passController,
                obscureText: _hidePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: theme.colorScheme.primary,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface.withValues(alpha: 0.5),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _hidePassword = !_hidePassword),
                  ),
                ),
                onFieldSubmitted: (_) => _login(),
                validator: (v) =>
                    v == null || v.length < 6 ? l10n.minCharacters(6) : null,
              ),
              const SizedBox(height: 32),
              _LoginButton(onPressed: _login),
              const SizedBox(height: 24),
              _OrDivider(l10n: l10n),
              const SizedBox(height: 24),
              const _GoogleSignInButton(),
              const SizedBox(height: 16),
              const _CreateAccountButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return GlassButton(
          onPressed: isLoading ? null : onPressed,
          padding: const .symmetric(vertical: 16),
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Row(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(Icons.login, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      l10n.loginButton,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: .w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _OrDivider extends StatelessWidget {
  final AppLocalizations l10n;

  const _OrDivider({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[400])),
        Padding(
          padding: const .symmetric(horizontal: 16),
          child: Text(
            l10n.orContinueWith,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[400])),
      ],
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.grey[300] : Colors.grey[800];

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return GlassButton(
          onPressed: isLoading
              ? null
              : () => context.read<AuthBloc>().add(
                  const AuthGoogleSignInRequested(),
                ),
          padding: const .symmetric(vertical: 14),
          variant: GlassButtonVariant.secondary,
          child: Row(
            mainAxisAlignment: .center,
            children: [
              Image.network(
                'https://www.google.com/favicon.ico',
                height: 20,
                width: 20,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.g_mobiledata, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.continueWithGoogle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: .w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return GlassButton(
      onPressed: () => context.push('/register'),
      padding: const .symmetric(vertical: 16),
      variant: GlassButtonVariant.outlined,
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Icon(
            Icons.person_add_outlined,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            l10n.createAccount,
            style: TextStyle(
              fontSize: 15,
              fontWeight: .w500,
              color: isDark
                  ? theme.colorScheme.primary.withValues(alpha: 0.9)
                  : theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
