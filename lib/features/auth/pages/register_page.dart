import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _adminCodeCtrl = TextEditingController();
  bool _showAdminCode = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _displayNameCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _adminCodeCtrl.dispose();
    super.dispose();
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final adminCode = _adminCodeCtrl.text.trim();

    context.read<AuthBloc>().add(
      AuthRegisterRequested(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        displayName: _displayNameCtrl.text.trim().isNotEmpty
            ? _displayNameCtrl.text.trim()
            : null,
        adminCode: adminCode.isNotEmpty ? adminCode : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.registrationError),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.ok),
                ),
              ],
            ),
          );
        } else if (state is AuthRegistrationSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.accountCreated)));
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.register)),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const .all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: .stretch,
                  children: [
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _displayNameCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.displayName,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.person_outline),
                        helperText: l10n.optional,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      validator: (v) => v == null || v.length < 6
                          ? l10n.minCharacters(6)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirmCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.confirmPassword,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      validator: (v) =>
                          v != _passCtrl.text ? l10n.passwordsDoNotMatch : null,
                    ),
                    const SizedBox(height: 16),

                    // Admin code section (collapsible)
                    InkWell(
                      onTap: () =>
                          setState(() => _showAdminCode = !_showAdminCode),
                      borderRadius: .circular(8),
                      child: Padding(
                        padding: const .symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(
                              _showAdminCode
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.adminCodeOptional,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: .w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: _showAdminCode
                          ? Column(
                              children: [
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _adminCodeCtrl,
                                  decoration: InputDecoration(
                                    labelText: l10n.adminCode,
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(
                                      Icons.admin_panel_settings,
                                    ),
                                    helperText: l10n.adminCodeHelper,
                                    helperMaxLines: 2,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 24),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: isLoading ? null : _submit,
                            icon: const Icon(Icons.person_add),
                            label: Text(
                              isLoading
                                  ? l10n.processing
                                  : l10n.createAccountButton,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
