/// Core package for stack template management
library core_samples;

export 'src/models/stack_template_manifest.dart';
export 'src/providers/stack_template_providers.dart';
export 'src/service/stack_template_service.dart';
export 'src/service/stack_template_installer.dart';

// Aliases for backward compatibility
import 'src/models/stack_template_manifest.dart';
import 'src/service/stack_template_service.dart';
import 'src/service/stack_template_installer.dart';
import 'package:core_stack_flutter/core_stack.dart';

typedef SampleStackManifest = StackTemplateManifest;
typedef SampleStackService = StackTemplateService;
typedef ManifestStackInstaller = StackTemplateInstaller;
typedef AssetStackManifest = AssetStackTemplateManifest;
