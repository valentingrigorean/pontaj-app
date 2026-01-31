import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/user.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';

class AdminUpgradeCard extends StatefulWidget {
  final User user;

  const AdminUpgradeCard({super.key, required this.user});

  @override
  State<AdminUpgradeCard> createState() => _AdminUpgradeCardState();
}

class _AdminUpgradeCardState extends State<AdminUpgradeCard> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isExpanded = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAdmin = widget.user.role == Role.admin;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.invalidAdminCode),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AuthAuthenticated &&
            state.user.role == Role.admin) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.upgradeSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: GlassCard(
        padding: const .all(20),
        enableBlur: false,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Container(
                  padding: const .all(8),
                  decoration: BoxDecoration(
                    color: isAdmin
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: .circular(8),
                  ),
                  child: Icon(
                    isAdmin ? Icons.verified_user : Icons.admin_panel_settings,
                    color: isAdmin ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        l10n.adminUpgrade,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
                      ),
                      if (!isAdmin)
                        Text(
                          l10n.adminUpgradeDesc,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
                if (isAdmin)
                  Container(
                    padding: const .symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: .circular(12),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.youAreAdmin,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: .w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (!isAdmin) ...[
              const SizedBox(height: 16),
              if (!_isExpanded)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _isExpanded = true),
                    icon: const Icon(Icons.arrow_upward),
                    label: Text(l10n.upgrade),
                  ),
                )
              else
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _codeController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: l10n.enterAdminCode,
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.adminCodeRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _isExpanded = false;
                                        _codeController.clear();
                                      });
                                    },
                              child: Text(l10n.cancel),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: _isLoading ? null : _onUpgrade,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(l10n.upgrade),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  void _onUpgrade() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final authBloc = context.read<AuthBloc>();
    final code = _codeController.text;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.confirmUpgrade),
        content: Text(l10n.confirmUpgradeMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.upgrade),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);
      authBloc.add(AuthUpgradeToAdminRequested(adminCode: code));
    }
  }
}
