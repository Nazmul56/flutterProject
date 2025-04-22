import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About This App',
                style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'This app is designed to provide users with helpful tools and information. '
                  'It is built using Flutter and demonstrates clean UI design, version tracking, '
                  'and modular development.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            Text(
              'Version: 1.0.0',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Build Number: 1',
              style: theme.textTheme.bodySmall,
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
