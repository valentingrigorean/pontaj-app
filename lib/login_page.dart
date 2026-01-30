import 'package:flutter/material.dart';

import 'widgets/glass_card.dart';
import 'widgets/gradient_background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final user = TextEditingController();
  final pass = TextEditingController();
  final form = GlobalKey<FormState>();
  bool hide = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    user.dispose();
    pass.dispose();
    super.dispose();
  }

  void login() {
    if (!form.currentState!.validate()) return;
    final u = user.text.trim();
    final p = pass.text;

    final isIlie = u.toLowerCase().contains('ilie');
    final isAdminCreds = isIlie && p == '1234';

    if (isAdminCreds) {
      Navigator.pushReplacementNamed(
        context,
        '/admin',
        arguments: {'user': u, 'adminMode': true},
      );
      return;
    }

    if (u.isNotEmpty && p.length >= 4) {
      Navigator.pushReplacementNamed(
        context,
        '/pontaj',
        arguments: {'user': u, 'adminMode': false, 'lockName': true},
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Credențiale invalide')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: MeshGradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _LogoHeader(theme: theme),
                      const SizedBox(height: 32),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 460),
                        child: GlassCard(
                          padding: const EdgeInsets.all(32),
                          child: Form(
                            key: form,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.secondary,
                                    ],
                                  ).createShader(bounds),
                                  child: Text(
                                    'Intră în cont',
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Gestionează pontajele rapid și intuitiv',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 28),
                                TextFormField(
                                  controller: user,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Utilizator',
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: theme.colorScheme.primary,
                                    ),
                                    filled: true,
                                    fillColor: theme.colorScheme.surface.withValues(alpha: 0.5),
                                  ),
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty ? 'Obligatoriu' : null,
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: pass,
                                  obscureText: hide,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    labelText: 'Parola',
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: theme.colorScheme.primary,
                                    ),
                                    filled: true,
                                    fillColor: theme.colorScheme.surface.withValues(alpha: 0.5),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        hide ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                      ),
                                      onPressed: () => setState(() => hide = !hide),
                                    ),
                                  ),
                                  onFieldSubmitted: (_) => login(),
                                  validator: (v) =>
                                      v == null || v.length < 4 ? 'Minim 4 caractere' : null,
                                ),
                                const SizedBox(height: 32),
                                GlassButton(
                                  onPressed: login,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.login, color: theme.colorScheme.primary),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Intră în aplicație',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GlassButton(
                                  onPressed: () => Navigator.pushNamed(context, '/register'),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person_add, size: 20, color: Colors.grey[700]),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Creează un cont nou',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  const _LogoHeader({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'JR',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
          ).createShader(bounds),
          child: Text(
            'PONTAJ PRO',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '10,000x Better Edition',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[500],
            letterSpacing: 1,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final adminName = args is Map && args['user'] is String
        ? (args['user'] as String)
        : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrator'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Setări',
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            tooltip: 'Deconectare',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: MeshGradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 32),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Salut, ${adminName.isEmpty ? 'Administrator' : adminName}',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Alege acțiunea dorită pentru a continua',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    children: [
                      _AdminActionTile(
                        icon: Icons.person_add_alt,
                        title: adminName.isEmpty ? 'Pontaj ca utilizator' : 'Pontaj ca $adminName',
                        subtitle: 'Adaugă pontaj pentru ziua curentă',
                        color: Theme.of(context).colorScheme.primary,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/pontaj',
                          arguments: {
                            'user': adminName.isEmpty ? 'Administrator' : adminName,
                            'adminMode': true,
                            'lockName': true,
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      _AdminActionTile(
                        icon: Icons.table_chart,
                        title: 'Vezi pontajele tuturor',
                        subtitle: 'Gestionează și analizează toate intrările',
                        color: Theme.of(context).colorScheme.secondary,
                        onTap: () => Navigator.pushNamed(context, '/entries'),
                      ),
                      const Divider(height: 1),
                      _AdminActionTile(
                        icon: Icons.attach_money,
                        title: 'Gestionează salarii',
                        subtitle: 'Configurează și calculează salariile',
                        color: Colors.green,
                        onTap: () => Navigator.pushNamed(context, '/entries'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AdminActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
