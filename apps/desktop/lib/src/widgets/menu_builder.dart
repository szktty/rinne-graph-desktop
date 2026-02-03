import 'package:flutter/material.dart' hide showAboutDialog;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart' as core_themes;
import 'package:features_settings/features_settings.dart';
import 'package:features_welcome/features_welcome.dart';
import 'package:features_updates/updates.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:presentation_components/presentation_components.dart';

import '../providers/app_state_providers.dart';
import '../providers/open_stacks_providers.dart';
import '../enums/activity_bar_index.dart';
import 'menu_actions.dart';
import 'about_dialog.dart';

/// Class responsible for building menu bar
class MenuBuilder {
  /// Build menu bar for macOS
  static List<PlatformMenuItem> buildMenus(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    return <PlatformMenuItem>[
      // 1. App menu (application menu)
      PlatformMenu(
        label: 'App',
        menus: <PlatformMenuItem>[
          // Custom About menu item
          PlatformMenuItem(
            label: 'About RinneGraph',
            onSelected: () {
              final navContext = navigatorKey.currentContext;
              if (navContext != null) {
                showAboutDialog(navContext);
              }
            },
          ),
          PlatformMenuItemGroup(
            members: <PlatformMenuItem>[
              PlatformMenuItem(
                label: 'Preferences...',
                shortcut: const SingleActivator(
                  LogicalKeyboardKey.comma,
                  meta: true,
                ),
                onSelected: () {
                  // Show settings dialog
                  showSettingsDialog(context);
                },
              ),
            ],
          ),
          if (PlatformProvidedMenuItem.hasMenu(
            PlatformProvidedMenuItemType.servicesSubmenu,
          ))
            const PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.servicesSubmenu,
            ),
          if (PlatformProvidedMenuItem.hasMenu(
            PlatformProvidedMenuItemType.hide,
          ))
            const PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.hide,
            ),
          if (PlatformProvidedMenuItem.hasMenu(
            PlatformProvidedMenuItemType.hideOtherApplications,
          ))
            const PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.hideOtherApplications,
            ),
          if (PlatformProvidedMenuItem.hasMenu(
            PlatformProvidedMenuItemType.showAllApplications,
          ))
            const PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.showAllApplications,
            ),
          if (PlatformProvidedMenuItem.hasMenu(
            PlatformProvidedMenuItemType.quit,
          ))
            const PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.quit,
            ),
        ],
      ),

      // 2. File menu
      _buildFileMenu(context, ref),

      // 3. Edit menu
      _buildEditMenu(context),

      // 4. View menu
      _buildViewMenu(context, ref),

      // 5. Graph menu
      _buildGraphMenu(),

      // 6. Window menu
      _buildWindowMenu(),

      // 7. Help menu
      _buildHelpMenu(navigatorKey, ref),
    ];
  }

  /// Build file menu
  static PlatformMenu _buildFileMenu(BuildContext context, WidgetRef ref) {
    return PlatformMenu(
      label: 'File',
      menus: <PlatformMenuItem>[
        PlatformMenuItem(
          label: 'New Stack...',
          shortcut: const SingleActivator(LogicalKeyboardKey.keyN, meta: true),
          onSelected: () {
            MenuActions.showCreateStackDialog(context);
          },
        ),
        PlatformMenuItem(
          label: 'Create Sample Stack...',
          onSelected: () {
            MenuActions.createSampleStack(context);
          },
        ),
        const PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: 'Open Stack...',
              shortcut: SingleActivator(LogicalKeyboardKey.keyO, meta: true),
            ),
            PlatformMenuItem(label: 'Recent Stacks'),
          ],
        ),
        const PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: 'Save',
              shortcut: SingleActivator(LogicalKeyboardKey.keyS, meta: true),
            ),
          ],
        ),
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: 'Close Stack',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyW,
                meta: true,
              ),
              onSelected: () {
                MenuActions.closeActiveStack(context);
              },
            ),
          ],
        ),
        const PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(label: 'Show Stack Info...'),
            PlatformMenuItem(
              label: 'Show in Finder',
              shortcut: SingleActivator(
                LogicalKeyboardKey.keyR,
                meta: true,
                alt: true,
              ),
            ),
          ],
        ),
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenu(
              label: 'Import',
              menus: <PlatformMenuItem>[
                PlatformMenuItem(
                  label: 'Import from CSV...',
                  onSelected: () => MenuActions.handleCsvImport(context, ref),
                ),
                const PlatformMenuItem(label: 'Import from JSON...'),
                const PlatformMenuItem(label: 'Import Stack...'),
              ],
            ),
            PlatformMenu(
              label: 'Export',
              menus: const <PlatformMenuItem>[
                PlatformMenuItem(label: 'Export to CSV...'),
                PlatformMenuItem(label: 'Export to JSON...'),
                PlatformMenuItem(label: 'Export Stack...'),
              ],
            ),
          ],
        ),
        const PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: 'Page Setup...',
              shortcut: SingleActivator(
                LogicalKeyboardKey.keyP,
                meta: true,
                shift: true,
              ),
            ),
            PlatformMenuItem(
              label: 'Print...',
              shortcut: SingleActivator(LogicalKeyboardKey.keyP, meta: true),
            ),
          ],
        ),
      ],
    );
  }

  /// Build edit menu
  static PlatformMenu _buildEditMenu(BuildContext context) {
    return PlatformMenu(
      label: 'Edit',
      menus: <PlatformMenuItem>[
        PlatformMenuItem(
          label: 'Undo',
          shortcut: const SingleActivator(LogicalKeyboardKey.keyZ, meta: true),
          onSelected: () {
            MenuActions.performUndo(context);
          },
        ),
        PlatformMenuItem(
          label: 'Redo',
          shortcut: const SingleActivator(
            LogicalKeyboardKey.keyZ,
            meta: true,
            shift: true,
          ),
          onSelected: () {
            MenuActions.performRedo(context);
          },
        ),
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: 'Cut',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyX,
                meta: true,
              ),
              onSelected: () {
                MenuActions.performCut(context);
              },
            ),
            PlatformMenuItem(
              label: 'Copy',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyC,
                meta: true,
              ),
              onSelected: () {
                MenuActions.performCopy(context);
              },
            ),
            PlatformMenuItem(
              label: 'Paste',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyV,
                meta: true,
              ),
              onSelected: () {
                MenuActions.performPaste(context);
              },
            ),
            PlatformMenuItem(
              label: 'Select All',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyA,
                meta: true,
              ),
              onSelected: () {
                MenuActions.performSelectAll(context);
              },
            ),
          ],
        ),
        const PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: 'Find...',
              shortcut: SingleActivator(LogicalKeyboardKey.keyF, meta: true),
            ),
            PlatformMenuItem(
              label: 'Replace...',
              shortcut: SingleActivator(
                LogicalKeyboardKey.keyF,
                meta: true,
                alt: true,
              ),
            ),
          ],
        ),
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenu(
              label: 'Spelling and Grammar',
              menus: const <PlatformMenuItem>[
                PlatformMenuItem(
                  label: 'Show Spelling and Grammar',
                  shortcut: SingleActivator(
                    LogicalKeyboardKey.semicolon,
                    meta: true,
                  ),
                ),
                PlatformMenuItem(label: 'Check Spelling While Typing'),
              ],
            ),
            PlatformMenu(
              label: 'Substitutions',
              menus: const <PlatformMenuItem>[
                PlatformMenuItem(label: 'Smart Substitutions'),
                PlatformMenuItem(label: 'Smart Quotes'),
                PlatformMenuItem(label: 'Smart Dashes'),
              ],
            ),
            PlatformMenu(
              label: 'Transformations',
              menus: const <PlatformMenuItem>[
                PlatformMenuItem(label: 'Make Uppercase'),
                PlatformMenuItem(label: 'Make Lowercase'),
                PlatformMenuItem(label: 'Capitalize'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Build view menu
  static PlatformMenu _buildViewMenu(BuildContext context, WidgetRef ref) {
    return PlatformMenu(
      label: 'View',
      menus: <PlatformMenuItem>[
        PlatformMenuItem(
          label: 'Pathfinder...',
          shortcut: const SingleActivator(LogicalKeyboardKey.keyP, meta: true),
          onSelected: () {
            // Action not implemented
          },
        ),
        const PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: 'Show/Hide Sidebar',
              shortcut: SingleActivator(LogicalKeyboardKey.digit1, meta: true),
            ),
            PlatformMenuItem(
              label: 'Show/Hide Detail Panel',
              shortcut: SingleActivator(LogicalKeyboardKey.digit2, meta: true),
            ),
            PlatformMenuItem(label: 'Show/Hide Toolbar'),
          ],
        ),
        const PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: 'Graph View',
              shortcut: SingleActivator(LogicalKeyboardKey.keyG, meta: true),
            ),
            PlatformMenuItem(
              label: 'Table View',
              shortcut: SingleActivator(LogicalKeyboardKey.keyT, meta: true),
            ),
          ],
        ),
        const PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: 'Zoom In',
              shortcut: SingleActivator(LogicalKeyboardKey.equal, meta: true),
            ),
            PlatformMenuItem(
              label: 'Zoom Out',
              shortcut: SingleActivator(LogicalKeyboardKey.minus, meta: true),
            ),
            PlatformMenuItem(
              label: 'Actual Size',
              shortcut: SingleActivator(LogicalKeyboardKey.digit0, meta: true),
            ),
          ],
        ),
        const PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: 'Full Screen',
              shortcut: SingleActivator(
                LogicalKeyboardKey.keyF,
                meta: true,
                control: true,
              ),
            ),
          ],
        ),
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenu(
              label: 'Theme Color',
              menus: _buildThemeColorMenuItems(ref),
            ),
          ],
        ),
      ],
    );
  }

  /// Build graph menu
  static PlatformMenu _buildGraphMenu() {
    return PlatformMenu(
      label: 'Graph',
      menus: const <PlatformMenuItem>[
        PlatformMenuItem(
          label: 'Create Node',
          shortcut: SingleActivator(
            LogicalKeyboardKey.keyN,
            meta: true,
            shift: true,
          ),
        ),
        PlatformMenuItem(
          label: 'Create Link',
          shortcut: SingleActivator(
            LogicalKeyboardKey.keyL,
            meta: true,
            shift: true,
          ),
        ),
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: 'Edit Properties',
              shortcut: SingleActivator(LogicalKeyboardKey.keyE, meta: true),
            ),
          ],
        ),
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: 'Add to Bookmarks',
              shortcut: SingleActivator(LogicalKeyboardKey.keyD, meta: true),
            ),
            PlatformMenuItem(label: 'Manage Bookmarks...'),
          ],
        ),
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(label: 'Save Chart as Image...'),
          ],
        ),
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: 'Delete',
              shortcut: SingleActivator(LogicalKeyboardKey.delete),
            ),
          ],
        ),
      ],
    );
  }

  /// Build window menu
  static PlatformMenu _buildWindowMenu() {
    return PlatformMenu(
      label: 'Window',
      menus: const <PlatformMenuItem>[
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.minimizeWindow,
        ),
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.zoomWindow),
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.arrangeWindowsInFront,
            ),
          ],
        ),
      ],
    );
  }

  /// Build help menu
  static PlatformMenu _buildHelpMenu(
    GlobalKey<NavigatorState> navigatorKey,
    WidgetRef ref,
  ) {
    return PlatformMenu(
      label: 'Help',
      menus: <PlatformMenuItem>[
        PlatformMenuItem(
          label: 'App Help',
          onSelected: () {
            // Action not implemented
          },
        ),
        PlatformMenuItem(
          label: 'Welcome',
          onSelected: () {
            // Check to prevent duplicate display
            final isWelcomeDialogShowing = ref.read(
              welcomeDialogShowingProvider,
            );
            if (isWelcomeDialogShowing) {
              return; // Do nothing if already showing
            }

            // Set flag
            ref.read(welcomeDialogShowingProvider.notifier).state = true;

            // Show welcome dialog
            final navigatorContext = navigatorKey.currentContext;
            if (navigatorContext != null) {
              showWelcomeDialog(
                navigatorContext,
                onCreateNewStack: () {
                  debugPrint('Create new stack from menu');
                },
                onOpenStack: () {
                  debugPrint('Open existing stack from menu');
                },
                onImportStack: () {
                  debugPrint('Import stack from menu');
                },
                onStackSelected: (selectedStack) async {
                  debugPrint(
                    'onStackSelected called from menu welcome: ${selectedStack.info.name}',
                  );
                  debugPrint(
                    'Selected stack path: ${selectedStack.directory.path}',
                  );

                  final navContext = navigatorKey.currentContext;
                  if (navContext == null) {
                    debugPrint('Navigation context is null, aborting');
                    return;
                  }

                  bool stackLoadedSuccessfully = false;
                  try {
                    // If same as current active stack, just close dialog
                    final currentActiveStack = ref.read(
                      core_stack.activeStackProvider,
                    );
                    debugPrint(
                      'Current active stack: ${currentActiveStack?.directory.path ?? 'null'}',
                    );

                    if (currentActiveStack?.directory.path ==
                        selectedStack.directory.path) {
                      debugPrint(
                        'Selected stack is already active, closing dialog',
                      );
                      stackLoadedSuccessfully = true;
                    } else {
                      // If different stack, perform switch
                      debugPrint('Switching to different stack from menu');
                      debugPrint('Setting active stack...');

                      // Open stack
                      ref
                          .read(core_stack.activeStackProvider.notifier)
                          .setStack(selectedStack);
                      debugPrint('Active stack set successfully');

                      ref
                          .read(openStacksActionsProvider.notifier)
                          .addStack(selectedStack);
                      debugPrint('Stack added to open stacks');

                      // Navigate to graph navigation screen
                      ref
                          .read(activityBarStateProvider.notifier)
                          .setIndex(ActivityBarIndex.graphNavigation.value);
                      debugPrint('Activity bar index set to graph navigation');

                      stackLoadedSuccessfully = true;
                      debugPrint(
                        'Stack loaded successfully from menu: ${selectedStack.info.name}',
                      );
                    }
                  } catch (e, stackTrace) {
                    debugPrint('Error loading stack from menu: $e');
                    debugPrint('Stack trace: $stackTrace');
                    if (navContext.mounted) {
                      await showAppErrorDialog(
                        navContext,
                        message:
                            'Error opening stack "${selectedStack.info.name}".',
                        details: '$e',
                      );
                    }
                  }

                  // Close welcome dialog only if stack loaded successfully
                  if (stackLoadedSuccessfully && navContext.mounted) {
                    debugPrint('Closing welcome dialog');
                    Navigator.of(navContext).pop();
                    // Reset flag when dialog is closed
                    ref.read(welcomeDialogShowingProvider.notifier).state =
                        false;
                    debugPrint('Welcome dialog closed successfully');
                  } else {
                    debugPrint(
                      'Stack loading failed or context not mounted, keeping dialog open',
                    );
                  }
                },
                onGoToMainScreen: () {
                  // Reset flag when dialog is closed
                  ref.read(welcomeDialogShowingProvider.notifier).state = false;
                },
              );
            }
          },
        ),
        PlatformMenuItem(
          label: 'Check for updates...',
          onSelected: () {
            // Show update check dialog
            final navigatorContext = navigatorKey.currentContext;
            if (navigatorContext != null) {
              showUpdateCheckDialog(navigatorContext);
            }
          },
        ),
        const PlatformMenuItem(label: 'Release Notes'),
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: 'Keyboard Shortcuts',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyK,
                meta: true,
                control: true,
              ),
              onSelected: () {
                // Action not implemented
              },
            ),
          ],
        ),
        const PlatformMenuItem(label: 'Send Feedback'),
      ],
    );
  }

  /// Build theme color selection menu items
  static List<PlatformMenuItem> _buildThemeColorMenuItems(WidgetRef ref) {
    final currentThemeType = ref.watch(core_themes.themeColorTypeProvider);

    return core_themes.ThemeColorType.values.map((themeType) {
      final colorDef = core_themes.ThemeColorScheme.defaultColors[themeType]!;
      final isSelected = themeType == currentThemeType;

      return PlatformMenuItem(
        label: '${isSelected ? "✓ " : ""}${colorDef.displayName}',
        onSelected: () {
          ref
              .read(core_themes.themeColorTypeProvider.notifier)
              .setThemeColor(themeType);
        },
      );
    }).toList();
  }
}
