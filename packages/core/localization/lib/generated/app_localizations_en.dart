// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get common_button_save => 'Save';

  @override
  String get common_button_cancel => 'Cancel';

  @override
  String get common_button_ok => 'OK';

  @override
  String get common_button_close => 'Close';

  @override
  String get common_button_delete => 'Delete';

  @override
  String get common_status_loading => 'Loading...';

  @override
  String get common_status_saving => 'Saving...';

  @override
  String get app_concept_stack => 'Stack';

  @override
  String get app_concept_entity => 'Entity';

  @override
  String get app_concept_node => 'Node';

  @override
  String get app_concept_edge => 'Edge';

  @override
  String get app_concept_graph => 'Graph';

  @override
  String get database_term_query => 'Query';

  @override
  String get database_term_property => 'Property';

  @override
  String get database_term_relation => 'Relation';

  @override
  String get error_network_connection => 'Network connection error';

  @override
  String get error_file_not_found => 'File not found';

  @override
  String get validation_required_field => 'This field is required';

  @override
  String get validation_must_be_integer => 'Value must be an integer';

  @override
  String get validation_must_be_decimal => 'Value must be a decimal number';

  @override
  String get validation_must_be_boolean => 'Value must be a boolean';

  @override
  String get validation_must_be_date => 'Value must be a date';

  @override
  String get validation_must_be_string => 'Value must be a string';

  @override
  String get validation_must_be_email => 'Value must be a valid email address';

  @override
  String validation_min_value(String min) {
    return 'Value must be at least $min';
  }

  @override
  String validation_max_value(String max) {
    return 'Value must be at most $max';
  }

  @override
  String validation_min_length(String minLength) {
    return 'Value must be at least $minLength characters';
  }

  @override
  String validation_max_length(String maxLength) {
    return 'Value must be at most $maxLength characters';
  }

  @override
  String get validation_pattern_mismatch =>
      'Value must match the specified pattern';

  @override
  String get validation_entity_id_empty => 'Entity ID cannot be empty';

  @override
  String validation_required_property_missing(String propertyName) {
    return 'Required property missing: $propertyName';
  }

  @override
  String validation_invalid_properties(String propertyList) {
    return 'Invalid properties: $propertyList';
  }

  @override
  String get validation_source_id_empty => 'Source node ID cannot be empty';

  @override
  String get validation_target_id_empty => 'Target node ID cannot be empty';

  @override
  String get validation_field_required => 'This field is required';

  @override
  String get validation_invalid_format => 'Invalid format';

  @override
  String get validation_value_too_short => 'Value is too short';

  @override
  String get validation_value_too_long => 'Value is too long';

  @override
  String get validation_invalid_characters => 'Contains invalid characters';

  @override
  String get validation_duplicate_value => 'This value is already in use';

  @override
  String get common_search => 'Search';

  @override
  String get common_filter => 'Filter';

  @override
  String get common_condition => 'Condition';

  @override
  String get common_create => 'Create';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_import => 'Import';

  @override
  String get common_export => 'Export';

  @override
  String get common_settings => 'Settings';

  @override
  String get common_help => 'Help';

  @override
  String get menu_file => 'File';

  @override
  String get menu_edit => 'Edit';

  @override
  String get menu_view => 'View';

  @override
  String get menu_window => 'Window';

  @override
  String get menu_graph => 'Graph';

  @override
  String get menu_help => 'Help';

  @override
  String get menu_settings => 'Settings...';

  @override
  String get menu_new_stack => 'New Stack...';

  @override
  String get menu_create_sample_stack => 'Create Sample Stack...';

  @override
  String get menu_open_stack => 'Open Stack...';

  @override
  String get menu_recent_stacks => 'Recent Stacks';

  @override
  String get menu_save => 'Save';

  @override
  String get menu_close_stack => 'Close Stack';

  @override
  String get menu_stack_info => 'Show Stack Info...';

  @override
  String get menu_show_in_finder => 'Show in Finder';

  @override
  String get menu_page_setup => 'Page Setup...';

  @override
  String get menu_print => 'Print...';

  @override
  String get menu_undo => 'Undo';

  @override
  String get menu_redo => 'Redo';

  @override
  String get menu_cut => 'Cut';

  @override
  String get menu_copy => 'Copy';

  @override
  String get menu_paste => 'Paste';

  @override
  String get menu_select_all => 'Select All';

  @override
  String get menu_find => 'Find...';

  @override
  String get menu_replace => 'Replace...';

  @override
  String get menu_spelling_grammar => 'Spelling and Grammar';

  @override
  String get menu_show_spelling_grammar => 'Show Spelling and Grammar';

  @override
  String get menu_check_spelling_while_typing => 'Check Spelling While Typing';

  @override
  String get menu_substitutions => 'Substitutions';

  @override
  String get menu_smart_substitutions => 'Smart Substitutions';

  @override
  String get menu_smart_quotes => 'Smart Quotes';

  @override
  String get menu_smart_dashes => 'Smart Dashes';

  @override
  String get menu_transformations => 'Transformations';

  @override
  String get menu_make_uppercase => 'Make Uppercase';

  @override
  String get menu_make_lowercase => 'Make Lowercase';

  @override
  String get menu_capitalize => 'Capitalize';

  @override
  String get menu_pathfinder => 'Pathfinder...';

  @override
  String get menu_background_tasks => 'Background Tasks...';

  @override
  String get menu_show_hide_sidebar => 'Show/Hide Sidebar';

  @override
  String get menu_show_hide_detail_panel => 'Show/Hide Detail Panel';

  @override
  String get menu_show_hide_toolbar => 'Show/Hide Toolbar';

  @override
  String get menu_graph_view => 'Graph View';

  @override
  String get menu_table_view => 'Table View';

  @override
  String get menu_zoom_in => 'Zoom In';

  @override
  String get menu_zoom_out => 'Zoom Out';

  @override
  String get menu_actual_size => 'Actual Size';

  @override
  String get menu_fullscreen => 'Enter Full Screen';

  @override
  String get menu_theme_color => 'Theme Color';

  @override
  String get menu_create_node => 'Create Node';

  @override
  String get menu_create_link => 'Create Link';

  @override
  String get menu_edit_properties => 'Edit Properties';

  @override
  String get menu_add_bookmark => 'Add Bookmark';

  @override
  String get menu_manage_bookmarks => 'Manage Bookmarks...';

  @override
  String get menu_save_chart_as_image => 'Save Chart as Image...';

  @override
  String get menu_delete => 'Delete';

  @override
  String get menu_app_help => 'App Help';

  @override
  String get menu_welcome => 'Welcome';

  @override
  String get menu_check_updates => 'Check for Updates...';

  @override
  String get menu_release_notes => 'Release Notes';

  @override
  String get menu_keyboard_shortcuts => 'Keyboard Shortcuts';

  @override
  String get menu_send_feedback => 'Send Feedback';

  @override
  String get settings_language_title => 'Language Settings';

  @override
  String get demo_title => 'Localization Demo';

  @override
  String get demo_description =>
      'This demo showcases the localization features of the App application.';

  @override
  String get demo_language_switch => 'Language Switch';

  @override
  String get demo_common_buttons => 'Common Buttons';

  @override
  String get demo_app_concepts => 'App Concepts';

  @override
  String get demo_database_terms => 'Database Terms';

  @override
  String get demo_error_messages => 'Error Messages';

  @override
  String get activity_graph_navigation => 'Graph Navigation';

  @override
  String get activity_advanced_search => 'Advanced Search';

  @override
  String get activity_settings => 'Settings';

  @override
  String get activity_stack_collection => 'Stack Collection';

  @override
  String get activity_entity_editor => 'Entity Editor';

  @override
  String get activity_welcome => 'Welcome';

  @override
  String get activity_label_list => 'Label List';

  @override
  String get activity_property_list => 'Property List';

  @override
  String get activity_ai_test => 'AI Test';

  @override
  String get screenshot_graph_navigation => 'Graph Navigation Screen';

  @override
  String get screenshot_settings_dialog => 'Settings Screen (Dialog)';

  @override
  String get screenshot_stack_collection => 'Stack Collection Screen';

  @override
  String get screenshot_entity_editor => 'Entity Editor Screen';

  @override
  String get screenshot_welcome => 'Welcome Screen';

  @override
  String get screenshot_metadata_editor => 'Metadata Management Screen';

  @override
  String get screenshot_background_tasks => 'Background Tasks Test Screen';

  @override
  String get error_csv_empty => 'CSV file is empty';

  @override
  String get error_csv_no_data => 'No data rows';

  @override
  String get error_csv_node_creation => 'Node creation error';

  @override
  String get error_csv_link_creation => 'Link creation error';

  @override
  String get error_csv_invalid_mapping =>
      'Invalid CSV mapping configuration. Node or Link configuration is required.';

  @override
  String get error_csv_import_failed => 'An error occurred during import';

  @override
  String get error_id_column_not_found => 'ID column not found';

  @override
  String get command_welcome_wait_closed => 'Wait for welcome to close';

  @override
  String get welcome_filter_language_all => 'All Languages';

  @override
  String get welcome_filter_language_unspecified => 'Unspecified';

  @override
  String get welcome_filter_language_label => 'Language';

  @override
  String get language_name_en => 'English';

  @override
  String get language_name_ja => 'Japanese';
}
