import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class DemoCredentialsWidget extends StatelessWidget {
  final void Function(String email, String password) onFillCredentials;

  const DemoCredentialsWidget({super.key, required this.onFillCredentials});

  static const _credentials = [
    {
      'role': 'Admin',
      'email': 'admin@familyhub.de',
      'password': 'FamilyHub2026!',
    },
    {
      'role': 'Mitglied',
      'email': 'maria@familyhub.de',
      'password': 'Familie2026#',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest
            : AppTheme.surfaceVariantLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: theme.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Demo-Zugangsdaten',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._credentials.map(
            (cred) => _CredentialRow(
              role: cred['role']!,
              email: cred['email']!,
              password: cred['password']!,
              onUse: () => onFillCredentials(cred['email']!, cred['password']!),
            ),
          ),
        ],
      ),
    );
  }
}

class _CredentialRow extends StatelessWidget {
  final String role;
  final String email;
  final String password;
  final VoidCallback onUse;

  const _CredentialRow({
    required this.role,
    required this.email,
    required this.password,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          StatusBadgeWidget(
            label: role,
            variant: role == 'Admin'
                ? BadgeVariant.primary
                : BadgeVariant.neutral,
            compact: true,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CopyableField(
                  label: email,
                  onCopy: () {
                    Clipboard.setData(ClipboardData(text: email));
                  },
                ),
                _CopyableField(
                  label: password,
                  onCopy: () {
                    Clipboard.setData(ClipboardData(text: password));
                  },
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onUse,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Nutzen',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyableField extends StatelessWidget {
  final String label;
  final VoidCallback onCopy;

  const _CopyableField({required this.label, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onCopy,
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
          fontSize: 11,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
