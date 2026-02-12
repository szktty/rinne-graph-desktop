import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Centralized management class for icons used throughout the App application.
///
/// This class manages all icons used in the app in one place,
/// promoting consistent icon usage.
class AppIcons {
  AppIcons._(); // Private constructor

  // Navigation related
  // TODO: The following icons are left for backward compatibility, but consider deleting them in the future.
  // Use app-specific names (stacks, graphNavigation, etc.) instead.
  static const IconData layers = LucideIcons.layers200; // Alternative: stacks
  static const IconData share2 =
      LucideIcons.share2200; // Alternative: graphNavigation
  static const IconData search = LucideIcons.search200;
  static const IconData bookmark =
      LucideIcons.bookmark200; // Alternative: bookmarks
  static const IconData database = LucideIcons.database200;
  static const IconData terminal =
      LucideIcons.terminal200; // Alternative: commandPalette
  static const IconData settings = LucideIcons.settings200;
  static const IconData keyboard = LucideIcons.keyboard200;

  // App-specific navigation and function icons
  // Recommendation: Use these icon names in new code.
  static const IconData stacks = LucideIcons.layers200;
  static const IconData graphNavigation = LucideIcons.share2200;
  static const IconData bookmarks = LucideIcons.bookmark200;
  static const IconData entityEditor = Icons.edit_note;
  static const IconData metadataEditor = LucideIcons.tag200;
  static const IconData commandPalette = LucideIcons.terminal200;

  // Panel operations
  static const IconData panelLeft = LucideIcons.panelLeft200;
  static const IconData panelLeftClose = LucideIcons.panelLeftClose200;
  static const IconData panelRight = LucideIcons.panelRight200;
  static const IconData panelRightClose = LucideIcons.panelRightClose200;

  // View types
  static const IconData table = LucideIcons.table200;
  static const IconData listTree = LucideIcons.listTree200;
  static const IconData calendar = LucideIcons.calendar200;
  static const IconData timeline = LucideIcons.clock200;

  // Actions
  static const IconData save = LucideIcons.import200;
  static const IconData rotateCcw = LucideIcons.rotateCcw200;
  static const IconData plus = LucideIcons.plus200;
  static const IconData x = LucideIcons.x200;
  static const IconData ellipsis = LucideIcons.ellipsis200;

  // Arrows and directions
  static const IconData arrowLeft = LucideIcons.arrowLeft200;
  static const IconData arrowRight = LucideIcons.arrowRight200;
  static const IconData arrowLeftRight = LucideIcons.arrowLeftRight200;
  static const IconData arrowUpDown = LucideIcons.arrowUpDown200;
  static const IconData chevronDown = LucideIcons.chevronDown200;

  // Check and selection
  static const IconData check = LucideIcons.check200;

  // Entity and data
  static const IconData circle = LucideIcons.circle200;
  static const IconData link = LucideIcons.link200;
  static const IconData tag =
      LucideIcons
          .tag200; // TODO: Alternative: metadataEditor (for metadata management purposes)
  static const IconData stickyNote = LucideIcons.stickyNote200;

  // Filter and sort
  static const IconData listFilter = LucideIcons.listFilter200;

  // Interaction
  static const IconData mousePointerClick = LucideIcons.mousePointerClick200;
  static const IconData gripVertical = LucideIcons.gripVertical200;
  static const IconData separatorVertical = LucideIcons.separatorVertical200;

  // Import operations
  static const IconData importAdd = LucideIcons.plus200; // Add import
  static const IconData importUpdate =
      LucideIcons.refreshCw200; // Update import (partial update)
  static const IconData importReplace =
      LucideIcons.arrowLeftRight200; // Replace import (full replacement)

  // Entity editor related
  static const IconData info = LucideIcons.info200;
  static const IconData id = LucideIcons.idCard200;
  static const IconData properties = LucideIcons.braces200;
  static const IconData connections = LucideIcons.circleArrowRight200;
  static const IconData display = LucideIcons.glasses200;

  // File and document
  static const IconData fileText = LucideIcons.fileText200;

  // List and display
  static const IconData list = LucideIcons.list200;

  // Settings and tools
  static const IconData settingsAdvanced = LucideIcons.settings2200;
  static const IconData download = LucideIcons.download200;
  static const IconData import = LucideIcons.import200;
  static const IconData appearance = LucideIcons.glasses200;
  static const IconData globe = LucideIcons.globe200;
  static const IconData accessibility = LucideIcons.personStanding200;
  static const IconData add = LucideIcons.plus200;
  static const IconData close = LucideIcons.x200;
  static const IconData command = LucideIcons.terminal200;
  static const IconData play = LucideIcons.play200;
  static const IconData zoom = LucideIcons.zoomIn200;
  static const IconData fit = LucideIcons.maximize200;
  static const IconData roadmap = LucideIcons.route200;
  static const IconData animation = LucideIcons.play200;
  static const IconData error = LucideIcons.badgeAlert200;
  static const IconData sun = LucideIcons.sun200;
  static const IconData moon = LucideIcons.moon200;

  // Material Icons (Flutter standard)
  // TODO: The following icons are left for backward compatibility, but consider deleting them in the future.
  static const IconData editNote = Icons.edit_note; // Alternative: entityEditor
  static const IconData barChart = Icons.bar_chart;
  static const IconData helpOutline = Icons.help_outline;
  static const IconData moreVert = Icons.more_vert;
  static const IconData clear = Icons.clear;
  static const IconData folderOpen = Icons.folder_open;
  static const IconData star = Icons.star;
  static const IconData starBorder = Icons.star_border;
  static const IconData pushPinOutlined = Icons.push_pin_outlined;
  static const IconData edit = Icons.edit;
  static const IconData copy = Icons.copy;
  static const IconData uploadFile = Icons.upload_file;
  static const IconData folder = Icons.folder;
  static const IconData archiveOutlined = Icons.archive_outlined;
  static const IconData deleteOutline = Icons.delete_outline;
}
