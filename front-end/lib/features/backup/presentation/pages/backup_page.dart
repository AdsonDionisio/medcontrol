import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Backup')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Proteja os dados do MedControl com copias de seguranca.',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Esta tela fica preparada para evoluir com backup local, exportacao e restauracao.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Iniciar backup'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
