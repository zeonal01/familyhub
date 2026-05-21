
import '../../../core/app_export.dart';

class LoginHeaderWidget extends StatelessWidget {
  final bool showForgotPassword;

  const LoginHeaderWidget({super.key, this.showForgotPassword = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withAlpha(64),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'home',
              color: theme.colorScheme.primary,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'FamilyHub',
          style: theme.textTheme.headlineLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          showForgotPassword ? 'Passwort zurücksetzen' : 'Willkommen zurück',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
