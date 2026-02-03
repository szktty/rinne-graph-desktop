import 'package:flutter/material.dart' hide Stack;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_stack_flutter/core_stack.dart';
import 'package:core_themes/core_themes.dart';

/// Demo widget for asset stack functionality.
class AssetStackDemo extends ConsumerWidget {
  const AssetStackDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement asset stacks provider when needed
    const assetStacks = <Stack>[];
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Asset Stacks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Stack templates embedded in the app:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            if (assetStacks.isEmpty)
              const Text(
                'No asset stack templates available',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            else
              Column(
                children:
                    assetStacks
                        .map(
                          (stack) => ListTile(
                            leading: const Icon(Icons.folder),
                            title: Text(stack.info.name),
                            subtitle: Text(
                              stack.info.description ?? 'No description',
                            ),
                            trailing:
                                stack.isAssetBased
                                    ? Chip(
                                      label: const Text('Template'),
                                      backgroundColor:
                                          appColorScheme
                                              .appSpecific
                                              .graph
                                              .nodeBase,
                                    )
                                    : null,
                          ),
                        )
                        .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
