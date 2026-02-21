import 'package:flutter_test/flutter_test.dart';
import 'package:core_samples/core_samples.dart';

void main() {
  group('SampleStackService', () {
    test('getAvailableStackTemplates returns correct stack templates', () {
      final stackTemplates = StackTemplateService.getAvailableStackTemplates();

      expect(stackTemplates.length, 4);

      // Meiji template
      final meijiTemplate = stackTemplates.firstWhere(
        (s) => s.id == 'meiji_sample',
      );
      expect(meijiTemplate.displayName, 'Bakumatsu Ryoma Relationship Chart');
      expect(meijiTemplate.fullAssetPath, 'packages/core_samples/assets/meiji');
      expect(meijiTemplate.category, 'history');

      // Graph of the Gods (English) template
      final graphOfTheGodsEnTemplate = stackTemplates.firstWhere(
        (s) => s.id == 'graph_of_the_gods',
      );
      expect(graphOfTheGodsEnTemplate.displayName, 'Graph of the Gods');
      expect(
        graphOfTheGodsEnTemplate.fullAssetPath,
        'packages/core_samples/assets/graph_of_the_gods',
      );
      expect(graphOfTheGodsEnTemplate.category, 'mythology');
      expect(graphOfTheGodsEnTemplate.language, 'en');

      // Graph of the Gods (Japanese) template
      final graphOfTheGodsJaTemplate = stackTemplates.firstWhere(
        (s) => s.id == 'graph_of_the_gods_ja',
      );
      expect(graphOfTheGodsJaTemplate.displayName, 'ギリシャ神のグラフ');
      expect(
        graphOfTheGodsJaTemplate.fullAssetPath,
        'packages/core_samples/assets/graph_of_the_gods_ja',
      );
      expect(graphOfTheGodsJaTemplate.category, 'mythology');
      expect(graphOfTheGodsJaTemplate.language, 'ja');
    });

    test(
      'getAssetStackTemplateManifests converts to AssetStackManifest correctly',
      () {
        final assetManifests =
            StackTemplateService.getAssetStackTemplateManifests();

        expect(assetManifests.length, 4);

        final meijiManifest = assetManifests.firstWhere(
          (m) => m.fullAssetPath == 'packages/core_samples/assets/meiji',
        );
        expect(meijiManifest.displayName, 'Bakumatsu Ryoma Relationship Chart');
        expect(meijiManifest.tags, contains('history'));
      },
    );

    test('getStackTemplatesByCategory filters correctly', () {
      final historyTemplates = StackTemplateService.getStackTemplatesByCategory(
        'history',
      );
      expect(historyTemplates.length, 1);
      expect(historyTemplates.first.id, 'meiji_sample');

      final nonExistentTemplates =
          StackTemplateService.getStackTemplatesByCategory('nonexistent');
      expect(nonExistentTemplates.length, 0);
    });

    test('getStackTemplateById returns correct template', () {
      final meijiTemplate = StackTemplateService.getStackTemplateById(
        'meiji_sample',
      );
      expect(meijiTemplate, isNotNull);
      expect(meijiTemplate!.displayName, 'Bakumatsu Ryoma Relationship Chart');

      final nonExistentTemplate = StackTemplateService.getStackTemplateById(
        'nonexistent',
      );
      expect(nonExistentTemplate, isNull);
    });
  });
}
