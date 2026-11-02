import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/features/settings/data/providers/ocr_engine_provider.dart';
import 'package:ant_budget/l10n/l10n.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final engine = ref.watch(ocrEngineProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.settingsReceiptScanning,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: RadioGroup<OcrEngine>(
              groupValue: engine,
              onChanged: (value) {
                if (value != null) {
                  ref.read(ocrEngineProvider.notifier).select(value);
                }
              },
              child: Column(
                children: [
                  RadioListTile<OcrEngine>(
                    value: OcrEngine.mlKit,
                    title: const Text('Google ML Kit'),
                    subtitle: Text(l10n.settingsMlKitDescription),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  RadioListTile<OcrEngine>(
                    value: OcrEngine.paddleOcr,
                    title: const Text('PaddleOCR'),
                    subtitle: Text(l10n.settingsPaddleDescription),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
