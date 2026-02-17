import 'package:flutter_test/flutter_test.dart';
import 'package:core_samples/core_samples.dart';

void main() {
  group('SampleStackService', () {
    test('getAvailableStackTemplates returns correct stack templates', () {
      final stackTemplates = StackTemplateService.getAvailableStackTemplates();

      expect(stackTemplates.length, 4);

      // Team template
      final teamTemplate = stackTemplates.firstWhere(
        (s) => s.id == 'team_sample',
      );
      expect(teamTemplate.displayName, 'Software Development Team Sample');
      expect(teamTemplate.fullAssetPath, 'packages/core_samples/assets/team');
      expect(teamTemplate.category, 'business');

      // Meiji template
      final meijiTemplate = stackTemplates.firstWhere(
        (s) => s.id == 'meiji_sample',
      );
      expect(meijiTemplate.displayName, 'Bakumatsu Ryoma Relationship Chart');
      expect(meijiTemplate.fullAssetPath, 'packages/core_samples/assets/meiji');
      expect(meijiTemplate.category, 'history');

      // Simple Graph template
      final simpleGraphTemplate = stackTemplates.firstWhere(
        (s) => s.id == 'simple_graph_sample',
      );
      expect(simpleGraphTemplate.displayName, 'Simple Graph Sample');
      expect(
        simpleGraphTemplate.fullAssetPath,
        'packages/core_samples/assets/simple_graph',
      );
      expect(simpleGraphTemplate.category, 'basic');
      expect(simpleGraphTemplate.language, 'en');

      // Graph of the Gods template
      final graphOfTheGodsTemplate = stackTemplates.firstWhere(
        (s) => s.id == 'graph_of_the_gods',
      );
      expect(graphOfTheGodsTemplate.displayName, 'Graph of the Gods');
      expect(
        graphOfTheGodsTemplate.fullAssetPath,
        'packages/core_samples/assets/graph_of_the_gods',
      );
      expect(graphOfTheGodsTemplate.category, 'mythology');
      expect(graphOfTheGodsTemplate.language, 'en');
    });

    test(
      'getAssetStackTemplateManifests converts to AssetStackManifest correctly',
      () {
        final assetManifests =
            StackTemplateService.getAssetStackTemplateManifests();

        expect(assetManifests.length, 4);

        final teamManifest = assetManifests.firstWhere(
          (m) => m.fullAssetPath == 'packages/core_samples/assets/team',
        );
        expect(teamManifest.displayName, 'Software Development Team Sample');
        expect(teamManifest.tags, contains('development'));
      },
    );

    test('getStackTemplatesByCategory filters correctly', () {
      final businessTemplates =
          StackTemplateService.getStackTemplatesByCategory('business');
      expect(businessTemplates.length, 1);
      expect(businessTemplates.first.id, 'team_sample');

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
      final teamTemplate = StackTemplateService.getStackTemplateById(
        'team_sample',
      );
      expect(teamTemplate, isNotNull);
      expect(teamTemplate!.displayName, 'Software Development Team Sample');

      final nonExistentTemplate = StackTemplateService.getStackTemplateById(
        'nonexistent',
      );
      expect(nonExistentTemplate, isNull);
    });
  });
}
