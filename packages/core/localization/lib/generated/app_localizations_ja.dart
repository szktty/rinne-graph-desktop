/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get common_button_save => '保存';

  @override
  String get common_button_cancel => 'キャンセル';

  @override
  String get common_button_ok => 'OK';

  @override
  String get common_button_close => '閉じる';

  @override
  String get common_button_delete => '削除';

  @override
  String get common_status_loading => '読み込み中...';

  @override
  String get common_status_saving => '保存中...';

  @override
  String get app_concept_stack => 'スタック';

  @override
  String get app_concept_entity => 'エンティティ';

  @override
  String get app_concept_node => 'ノード';

  @override
  String get app_concept_edge => 'エッジ';

  @override
  String get app_concept_graph => 'グラフ';

  @override
  String get database_term_query => 'クエリ';

  @override
  String get database_term_property => 'プロパティ';

  @override
  String get database_term_relation => 'リレーション';

  @override
  String get error_network_connection => 'ネットワーク接続エラー';

  @override
  String get error_file_not_found => 'ファイルが存在しません';

  @override
  String get validation_required_field => 'この項目は必須です';

  @override
  String get validation_must_be_integer => '値は整数である必要があります';

  @override
  String get validation_must_be_decimal => '値は小数である必要があります';

  @override
  String get validation_must_be_boolean => '値は真偽値である必要があります';

  @override
  String get validation_must_be_date => '値は日付である必要があります';

  @override
  String get validation_must_be_string => '値は文字列である必要があります';

  @override
  String get validation_must_be_email => '値は有効なメールアドレスである必要があります';

  @override
  String validation_min_value(String min) {
    return '値は$min以上である必要があります';
  }

  @override
  String validation_max_value(String max) {
    return '値は$max以下である必要があります';
  }

  @override
  String validation_min_length(String minLength) {
    return '値は$minLength文字以上である必要があります';
  }

  @override
  String validation_max_length(String maxLength) {
    return '値は$maxLength文字以下である必要があります';
  }

  @override
  String get validation_pattern_mismatch => '値は指定された形式と一致する必要があります';

  @override
  String get validation_entity_id_empty => 'エンティティIDが空です';

  @override
  String validation_required_property_missing(String propertyName) {
    return '必須プロパティが不足しています: $propertyName';
  }

  @override
  String validation_invalid_properties(String propertyList) {
    return '無効なプロパティ: $propertyList';
  }

  @override
  String get validation_source_id_empty => '開始ノードIDが空です';

  @override
  String get validation_target_id_empty => '終了ノードIDが空です';

  @override
  String get validation_field_required => 'この項目は必須です';

  @override
  String get validation_invalid_format => '形式が正しくありません';

  @override
  String get validation_value_too_short => '値が短すぎます';

  @override
  String get validation_value_too_long => '値が長すぎます';

  @override
  String get validation_invalid_characters => '使用できない文字が含まれています';

  @override
  String get validation_duplicate_value => 'この値は既に使用されています';

  @override
  String get common_search => '検索';

  @override
  String get common_filter => 'フィルター';

  @override
  String get common_condition => '条件';

  @override
  String get common_create => '作成';

  @override
  String get common_edit => '編集';

  @override
  String get common_import => 'インポート';

  @override
  String get common_export => 'エクスポート';

  @override
  String get common_settings => '設定';

  @override
  String get common_help => 'ヘルプ';

  @override
  String get menu_file => 'ファイル';

  @override
  String get menu_edit => '編集';

  @override
  String get menu_view => '表示';

  @override
  String get menu_window => 'ウインドウ';

  @override
  String get menu_graph => 'グラフ';

  @override
  String get menu_help => 'ヘルプ';

  @override
  String get menu_settings => '設定...';

  @override
  String get menu_new_stack => '新規スタック...';

  @override
  String get menu_create_sample_stack => 'サンプルスタックを作成...';

  @override
  String get menu_open_stack => 'スタックを開く...';

  @override
  String get menu_recent_stacks => '最近使用したスタック';

  @override
  String get menu_save => '保存';

  @override
  String get menu_close_stack => 'スタックを閉じる';

  @override
  String get menu_stack_info => 'スタック情報を表示...';

  @override
  String get menu_show_in_finder => 'Finderで表示';

  @override
  String get menu_page_setup => 'ページ設定...';

  @override
  String get menu_print => '印刷...';

  @override
  String get menu_undo => '取り消す';

  @override
  String get menu_redo => 'やり直す';

  @override
  String get menu_cut => '切り取り';

  @override
  String get menu_copy => 'コピー';

  @override
  String get menu_paste => '貼り付け';

  @override
  String get menu_select_all => 'すべて選択';

  @override
  String get menu_find => '検索...';

  @override
  String get menu_replace => '置換...';

  @override
  String get menu_spelling_grammar => 'スペルと文法';

  @override
  String get menu_show_spelling_grammar => 'スペルと文法を表示';

  @override
  String get menu_check_spelling_while_typing => '書類の入力中にスペルをチェック';

  @override
  String get menu_substitutions => '置換';

  @override
  String get menu_smart_substitutions => 'スマート置換';

  @override
  String get menu_smart_quotes => 'スマート引用符';

  @override
  String get menu_smart_dashes => 'スマートダッシュ';

  @override
  String get menu_transformations => '変換';

  @override
  String get menu_make_uppercase => '大文字に';

  @override
  String get menu_make_lowercase => '小文字に';

  @override
  String get menu_capitalize => '先頭を大文字に';

  @override
  String get menu_pathfinder => 'パスファインダー...';

  @override
  String get menu_background_tasks => 'バックグラウンドタスク...';

  @override
  String get menu_show_hide_sidebar => 'サイドバーを表示/隠す';

  @override
  String get menu_show_hide_detail_panel => '詳細パネルを表示/隠す';

  @override
  String get menu_show_hide_toolbar => 'ツールバーを表示/隠す';

  @override
  String get menu_graph_view => 'グラフビュー';

  @override
  String get menu_table_view => 'テーブルビュー';

  @override
  String get menu_zoom_in => '拡大';

  @override
  String get menu_zoom_out => '縮小';

  @override
  String get menu_actual_size => '実際のサイズ';

  @override
  String get menu_fullscreen => '全画面表示';

  @override
  String get menu_theme_color => 'テーマカラー';

  @override
  String get menu_create_node => 'ノードを作成';

  @override
  String get menu_create_link => 'リンクを作成';

  @override
  String get menu_edit_properties => 'プロパティを編集';

  @override
  String get menu_add_bookmark => 'ブックマークに追加';

  @override
  String get menu_manage_bookmarks => 'ブックマークを管理...';

  @override
  String get menu_save_chart_as_image => 'チャートを画像で保存...';

  @override
  String get menu_delete => '削除';

  @override
  String get menu_app_help => 'RinneGraphヘルプ';

  @override
  String get menu_welcome => 'ようこそ';

  @override
  String get menu_check_updates => 'Check for updates...';

  @override
  String get menu_release_notes => 'リリースノート';

  @override
  String get menu_keyboard_shortcuts => 'キーボードショートカット';

  @override
  String get menu_send_feedback => 'フィードバックを送信';

  @override
  String get settings_language_title => '言語設定';

  @override
  String get demo_title => 'ローカライズデモ';

  @override
  String get demo_description => 'このデモでは、RinneGraphアプリケーションのローカライズ機能を確認できます。';

  @override
  String get demo_language_switch => '言語切り替え';

  @override
  String get demo_common_buttons => '共通ボタン';

  @override
  String get demo_app_concepts => 'RinneGraph概念';

  @override
  String get demo_database_terms => 'データベース用語';

  @override
  String get demo_error_messages => 'エラーメッセージ';

  @override
  String get activity_graph_navigation => 'グラフナビゲーション';

  @override
  String get activity_advanced_search => '高度な検索';

  @override
  String get activity_settings => '設定';

  @override
  String get activity_stack_collection => 'スタックコレクション';

  @override
  String get activity_entity_editor => 'エンティティエディタ';

  @override
  String get activity_welcome => 'ウェルカム';

  @override
  String get activity_label_list => 'ラベル一覧';

  @override
  String get activity_property_list => 'プロパティ一覧';

  @override
  String get activity_ai_test => 'AIテスト';

  @override
  String get screenshot_graph_navigation => 'グラフナビゲーション画面';

  @override
  String get screenshot_settings_dialog => '設定画面（ダイアログ）';

  @override
  String get screenshot_stack_collection => 'スタックコレクション画面';

  @override
  String get screenshot_entity_editor => 'エンティティエディタ画面';

  @override
  String get screenshot_welcome => 'ウェルカム画面';

  @override
  String get screenshot_metadata_editor => 'メタデータ管理画面';

  @override
  String get screenshot_background_tasks => 'バックグラウンドタスクテスト画面';

  @override
  String get error_csv_empty => 'CSVファイルが空です';

  @override
  String get error_csv_no_data => 'データ行がありません';

  @override
  String get error_csv_node_creation => 'ノード作成エラー';

  @override
  String get error_csv_link_creation => 'リンク作成エラー';

  @override
  String get error_csv_invalid_mapping => 'CSVマッピング設定が不正です。ノードまたはリンクの設定が必要です。';

  @override
  String get error_csv_import_failed => 'インポート中にエラーが発生しました';

  @override
  String get error_id_column_not_found => 'IDカラムが見つかりません';

  @override
  String get command_welcome_wait_closed => 'ウェルカムが閉じられるまで待機';

  @override
  String get welcome_filter_language_all => 'すべての言語';

  @override
  String get welcome_filter_language_unspecified => '未指定';

  @override
  String get welcome_filter_language_label => '言語';

  @override
  String get language_name_en => '英語';

  @override
  String get language_name_ja => '日本語';
}
