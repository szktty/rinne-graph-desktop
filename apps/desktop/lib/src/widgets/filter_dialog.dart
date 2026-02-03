import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';

import '../providers/filter_providers.dart';

/// Filter settings dialog
class FilterDialog extends ConsumerStatefulWidget {
  const FilterDialog({super.key});

  @override
  ConsumerState<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends ConsumerState<FilterDialog> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final filterState = ref.read(filterStateProvider);
    _searchController = TextEditingController(text: filterState.searchQuery);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(filterStateProvider);
    final filterNotifier = ref.read(filterStateProvider.notifier);

    return AppDialog(
      title: 'Filters',
      width: 640,
      height: 600,
      showCloseButton: true,
      importance: DialogImportance.utility,
      footer: _buildFooter(filterNotifier),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search field and action menu
          Row(
            children: [
              Expanded(
                child: AppSearchField(
                  value: _searchController.text,
                  hint: 'Filter...',
                  onChange: (value) {
                    _searchController.text = value;
                    filterNotifier.updateSearchQuery(value);
                  },
                  onClear: () {
                    _searchController.clear();
                    filterNotifier.updateSearchQuery('');
                  },
                ),
              ),
              const SizedBox(width: 8),
              _buildActionDropdown(filterNotifier),
            ],
          ),

          const SizedBox(height: 16),

          // Collapsible section list (scrollable)
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true, // Always show scrollbar
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    _buildNodeLabelsSection(filterState, filterNotifier),
                    const SizedBox(height: 8),
                    _buildLinkTypesSection(filterState, filterNotifier),
                    const SizedBox(height: 8),
                    _buildPropertiesSection(filterState, filterNotifier),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNodeLabelsSection(
    FilterState filterState,
    FilterNotifier filterNotifier,
  ) {
    final nodeLabels = ref.watch(availableNodeLabelsProvider);

    return AppExpansionTile(
      title: AppText('Nodes', variant: AppTextVariant.sectionTitleUtility),
      initiallyExpanded: true,
      childrenPadding: const EdgeInsets.all(16),
      children: [
        _buildTagList(
          nodeLabels,
          filterState.selectedNodeLabels,
          (label) => filterNotifier.toggleNodeLabel(label),
        ),
      ],
    );
  }

  Widget _buildLinkTypesSection(
    FilterState filterState,
    FilterNotifier filterNotifier,
  ) {
    final linkTypes = ref.watch(availableLinkTypesProvider);

    return AppExpansionTile(
      title: AppText('Links', variant: AppTextVariant.sectionTitleUtility),
      initiallyExpanded: true,
      childrenPadding: const EdgeInsets.all(16),
      children: [
        _buildTagList(
          linkTypes,
          filterState.selectedLinkTypes,
          (linkType) => filterNotifier.toggleLinkType(linkType),
        ),
      ],
    );
  }

  Widget _buildPropertiesSection(
    FilterState filterState,
    FilterNotifier filterNotifier,
  ) {
    final properties = ref.watch(availablePropertiesProvider);

    return AppExpansionTile(
      title: AppText('Properties', variant: AppTextVariant.sectionTitleUtility),
      initiallyExpanded: true,
      childrenPadding: const EdgeInsets.all(16),
      children: [
        _buildTagList(
          properties,
          filterState.selectedProperties,
          (property) => filterNotifier.toggleProperty(property),
        ),
      ],
    );
  }

  Widget _buildTagList(
    List<String> items,
    Set<String> selectedItems,
    void Function(String) onToggle,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          items
              .map(
                (item) => _buildSelectableTag(
                  item,
                  selectedItems.contains(item),
                  () => onToggle(item),
                ),
              )
              .toList(),
    );
  }

  Widget _buildSelectableTag(
    String title,
    bool isSelected,
    VoidCallback onToggle,
  ) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? appColorScheme.theme.primaryColor.withAlpha(
                    51,
                  ) // 20% opacity
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? appColorScheme.theme.primaryColor.withAlpha(
                      128,
                    ) // 50% opacity
                    : appColorScheme.base.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              size: 16,
              color:
                  isSelected
                      ? appColorScheme.theme.primaryColor
                      : appColorScheme.base.foreground.withAlpha(128),
            ),
            const SizedBox(width: 6),
            AppText(
              title,
              variant: AppTextVariant.bodyText,
              color:
                  isSelected
                      ? appColorScheme.theme.primaryColor
                      : appColorScheme.base.foreground,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionDropdown(FilterNotifier filterNotifier) {
    return AppDropdownMenu<String>(
      showAsActionIcon: true,
      dropdownMenuEntries: [
        DropdownMenuEntry(value: 'select_all', label: 'Select All'),
        DropdownMenuEntry(value: 'select_nodes', label: 'Nodes Only'),
        DropdownMenuEntry(value: 'select_links', label: 'Links Only'),
        DropdownMenuEntry(value: 'clear_all', label: 'Clear All'),
      ],
      onSelected: (value) {
        switch (value) {
          case 'select_all':
            filterNotifier.selectAll();
            break;
          case 'select_nodes':
            filterNotifier.selectNodesOnly();
            break;
          case 'select_links':
            filterNotifier.selectLinksOnly();
            break;
          case 'clear_all':
            filterNotifier.reset();
            _searchController.clear();
            break;
        }
      },
    );
  }

  Widget _buildFooter(FilterNotifier filterNotifier) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.base.border, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacingValues.xl),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton.cancel(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 12),
            AppButton.primary(
              label: 'Apply',
              onPressed: () {
                // TODO: Apply filter processing
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
