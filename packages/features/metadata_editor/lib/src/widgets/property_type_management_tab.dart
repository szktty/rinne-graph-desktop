import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_graph_flutter/core_graph.dart';

/// Property Type Management Tab
class PropertyTypeManagementTab extends ConsumerStatefulWidget {
  const PropertyTypeManagementTab({super.key});

  @override
  ConsumerState<PropertyTypeManagementTab> createState() =>
      _PropertyTypeManagementTabState();
}

class _PropertyTypeManagementTabState
    extends ConsumerState<PropertyTypeManagementTab> {
  late GlobalPropertyTypeManager _manager;
  List<GlobalPropertyTypeDefinition> _propertyTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeManager();
  }

  Future<void> _initializeManager() async {
    try {
      // TODO: Get actual stack path
      const stackPath = '/tmp/test_stack';
      _manager = GlobalPropertyTypeManager(stackPath);
      await _loadPropertyTypes();
    } catch (e) {
      debugPrint('Failed to initialize property type manager: $e');
    }
  }

  Future<void> _loadPropertyTypes() async {
    try {
      setState(() => _isLoading = true);
      final typesMap = await _manager.getAllPropertyTypes();
      setState(() {
        _propertyTypes = typesMap.values.toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Failed to load property types: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppText(
                      'Property Type Management',
                      variant: AppTextVariant.sectionTitlePrimary,
                    ),
                    AppButton.primary(
                      label: 'Add Property Type',
                      onPressed: _showAddPropertyTypeDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const AppText(
                  'Manage property types for entities.',
                  variant: AppTextVariant.bodyText,
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildPropertyTypeList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyTypeList() {
    if (_propertyTypes.isEmpty) {
      return const Center(
        child: AppText(
          'No property types registered',
          variant: AppTextVariant.bodyText,
        ),
      );
    }

    return AppContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header row
          Row(
            children: [
              const Expanded(
                flex: 2,
                child: AppText(
                  'Property Name',
                  variant: AppTextVariant.captionText,
                ),
              ),
              const Expanded(
                child: AppText('Type', variant: AppTextVariant.captionText),
              ),
              const Expanded(
                flex: 2,
                child: AppText(
                  'Display Name',
                  variant: AppTextVariant.captionText,
                ),
              ),
              const SizedBox(
                width: 100,
                child: AppText('Actions', variant: AppTextVariant.captionText),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const AppDivider(),
          const SizedBox(height: 8),

          // Property type list
          ...(_propertyTypes.map(
            (propertyType) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AppText(
                      propertyType.typeName,
                      variant: AppTextVariant.bodyText,
                    ),
                  ),
                  Expanded(
                    child: AppText(
                      propertyType.typeName,
                      variant: AppTextVariant.bodyText,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AppText(
                      propertyType.name ?? propertyType.typeName,
                      variant: AppTextVariant.bodyText,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        AppIconButton(
                          icon: AppIcons.edit,
                          onPressed:
                              () => _showEditPropertyTypeDialog(propertyType),
                        ),
                        const SizedBox(width: 8),
                        AppIconButton(
                          icon: AppIcons.x,
                          onPressed:
                              () => _showDeletePropertyTypeDialog(propertyType),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  void _showAddPropertyTypeDialog() {
    // TODO: Implement add property type dialog
    debugPrint('Display add property type dialog');
  }

  void _showEditPropertyTypeDialog(GlobalPropertyTypeDefinition propertyType) {
    // TODO: Implement edit property type dialog
    debugPrint('Display edit property type dialog: ${propertyType.typeName}');
  }

  void _showDeletePropertyTypeDialog(
    GlobalPropertyTypeDefinition propertyType,
  ) {
    // TODO: Implement delete property type dialog
    debugPrint('Display delete property type dialog: ${propertyType.typeName}');
  }
}
