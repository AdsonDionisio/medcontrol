import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class MeasurementsPage extends StatelessWidget {
  const MeasurementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Afericoes', style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Area reservada para pressao, glicemia e outras afericoes importantes.',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
