import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/pages/share_server/receive_page.dart';
import 'package:than_reader/platforms/pages/share_server/share_page.dart';

class ServerHomePage extends StatelessWidget {
  const ServerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          width: 420,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: col.surfaceContainer,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: col.outlineVariant),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.share_outlined, size: 48, color: col.primary),
              const SizedBox(height: 12),
              Text(
                'Share files',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Send and receive files over your local network.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: col.onSurfaceVariant),
              ),
              const SizedBox(height: 24),

              _ActionButton(
                icon: Icons.upload_rounded,
                title: 'Share',
                subtitle: 'Send files to another device',
                onTap: () {
                  context.pushMaterialPageRoute(builder: (_) => SharePage());
                },
              ),

              const SizedBox(height: 12),

              _ActionButton(
                icon: Icons.download_rounded,
                title: 'Receive',
                subtitle: 'Receive files from another device',
                onTap: () {
                  context.pushMaterialPageRoute(builder: (_) => ReceivePage());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;

    return Material(
      color: col.primaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: col.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: col.onPrimary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: col.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: col.onPrimaryContainer.withValues(alpha: .7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: col.onPrimaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
