import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// 共通の保存ボタンのラベル
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get common_button_save;

  /// 共通のキャンセルボタンのラベル
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get common_button_cancel;

  /// 共通のOKボタンのラベル
  ///
  /// In ja, this message translates to:
  /// **'OK'**
  String get common_button_ok;

  /// 共通の閉じるボタンのラベル
  ///
  /// In ja, this message translates to:
  /// **'閉じる'**
  String get common_button_close;

  /// 共通の削除ボタンのラベル
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get common_button_delete;

  /// データ読み込み中の状態表示
  ///
  /// In ja, this message translates to:
  /// **'読み込み中...'**
  String get common_status_loading;

  /// データ保存中の状態表示
  ///
  /// In ja, this message translates to:
  /// **'保存中...'**
  String get common_status_saving;

  /// RinneGraph固有概念：データベースの単位
  ///
  /// In ja, this message translates to:
  /// **'スタック'**
  String get app_concept_stack;

  /// RinneGraph固有概念：グラフの要素
  ///
  /// In ja, this message translates to:
  /// **'エンティティ'**
  String get app_concept_entity;

  /// RinneGraph固有概念：グラフのノード
  ///
  /// In ja, this message translates to:
  /// **'ノード'**
  String get app_concept_node;

  /// RinneGraph固有概念：グラフのエッジ
  ///
  /// In ja, this message translates to:
  /// **'エッジ'**
  String get app_concept_edge;

  /// RinneGraph固有概念：グラフ構造
  ///
  /// In ja, this message translates to:
  /// **'グラフ'**
  String get app_concept_graph;

  /// データベース専門用語：検索クエリ
  ///
  /// In ja, this message translates to:
  /// **'クエリ'**
  String get database_term_query;

  /// データベース専門用語：属性
  ///
  /// In ja, this message translates to:
  /// **'プロパティ'**
  String get database_term_property;

  /// データベース専門用語：関係
  ///
  /// In ja, this message translates to:
  /// **'リレーション'**
  String get database_term_relation;

  /// ネットワーク接続に失敗した場合のエラーメッセージ
  ///
  /// In ja, this message translates to:
  /// **'ネットワーク接続エラー'**
  String get error_network_connection;

  /// ファイルが存在しない場合のエラーメッセージ
  ///
  /// In ja, this message translates to:
  /// **'ファイルが存在しません'**
  String get error_file_not_found;

  /// 必須項目が入力されていない場合のバリデーションメッセージ
  ///
  /// In ja, this message translates to:
  /// **'この項目は必須です'**
  String get validation_required_field;

  /// 整数型バリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'値は整数である必要があります'**
  String get validation_must_be_integer;

  /// 小数型バリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'値は小数である必要があります'**
  String get validation_must_be_decimal;

  /// 真偽値型バリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'値は真偽値である必要があります'**
  String get validation_must_be_boolean;

  /// 日付型バリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'値は日付である必要があります'**
  String get validation_must_be_date;

  /// 文字列型バリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'値は文字列である必要があります'**
  String get validation_must_be_string;

  /// メールアドレス型バリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'値は有効なメールアドレスである必要があります'**
  String get validation_must_be_email;

  /// 最小値バリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'値は{min}以上である必要があります'**
  String validation_min_value(String min);

  /// 最大値バリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'値は{max}以下である必要があります'**
  String validation_max_value(String max);

  /// 最小文字数バリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'値は{minLength}文字以上である必要があります'**
  String validation_min_length(String minLength);

  /// 最大文字数バリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'値は{maxLength}文字以下である必要があります'**
  String validation_max_length(String maxLength);

  /// パターンマッチングバリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'値は指定された形式と一致する必要があります'**
  String get validation_pattern_mismatch;

  /// エンティティIDが空の場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'エンティティIDが空です'**
  String get validation_entity_id_empty;

  /// 必須プロパティが不足している場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'必須プロパティが不足しています: {propertyName}'**
  String validation_required_property_missing(String propertyName);

  /// 無効なプロパティがある場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'無効なプロパティ: {propertyList}'**
  String validation_invalid_properties(String propertyList);

  /// リンクの開始ノードIDが空の場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'開始ノードIDが空です'**
  String get validation_source_id_empty;

  /// リンクの終了ノードIDが空の場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'終了ノードIDが空です'**
  String get validation_target_id_empty;

  /// フォーム項目が必須の場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'この項目は必須です'**
  String get validation_field_required;

  /// 入力形式が正しくない場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'形式が正しくありません'**
  String get validation_invalid_format;

  /// 入力値が短すぎる場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'値が短すぎます'**
  String get validation_value_too_short;

  /// 入力値が長すぎる場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'値が長すぎます'**
  String get validation_value_too_long;

  /// 使用できない文字が含まれている場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'使用できない文字が含まれています'**
  String get validation_invalid_characters;

  /// 重複する値が入力された場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'この値は既に使用されています'**
  String get validation_duplicate_value;

  /// 検索機能の共通ラベル
  ///
  /// In ja, this message translates to:
  /// **'検索'**
  String get common_search;

  /// フィルター機能の共通ラベル
  ///
  /// In ja, this message translates to:
  /// **'フィルター'**
  String get common_filter;

  /// 検索条件の共通ラベル
  ///
  /// In ja, this message translates to:
  /// **'条件'**
  String get common_condition;

  /// 新規作成の共通ラベル
  ///
  /// In ja, this message translates to:
  /// **'作成'**
  String get common_create;

  /// 編集の共通ラベル
  ///
  /// In ja, this message translates to:
  /// **'編集'**
  String get common_edit;

  /// データインポートの共通ラベル
  ///
  /// In ja, this message translates to:
  /// **'インポート'**
  String get common_import;

  /// データエクスポートの共通ラベル
  ///
  /// In ja, this message translates to:
  /// **'エクスポート'**
  String get common_export;

  /// 設定の共通ラベル
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get common_settings;

  /// ヘルプの共通ラベル
  ///
  /// In ja, this message translates to:
  /// **'ヘルプ'**
  String get common_help;

  /// ファイルメニューのラベル
  ///
  /// In ja, this message translates to:
  /// **'ファイル'**
  String get menu_file;

  /// 編集メニューのラベル
  ///
  /// In ja, this message translates to:
  /// **'編集'**
  String get menu_edit;

  /// 表示メニューのラベル
  ///
  /// In ja, this message translates to:
  /// **'表示'**
  String get menu_view;

  /// ウインドウメニューのラベル
  ///
  /// In ja, this message translates to:
  /// **'ウインドウ'**
  String get menu_window;

  /// グラフメニューのラベル
  ///
  /// In ja, this message translates to:
  /// **'グラフ'**
  String get menu_graph;

  /// ヘルプメニューのラベル
  ///
  /// In ja, this message translates to:
  /// **'ヘルプ'**
  String get menu_help;

  /// 設定メニュー項目のラベル
  ///
  /// In ja, this message translates to:
  /// **'設定...'**
  String get menu_settings;

  /// 新規スタック作成メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'新規スタック...'**
  String get menu_new_stack;

  /// サンプルスタック作成メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'サンプルスタックを作成...'**
  String get menu_create_sample_stack;

  /// スタックを開くメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'スタックを開く...'**
  String get menu_open_stack;

  /// 最近使用したスタックメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'最近使用したスタック'**
  String get menu_recent_stacks;

  /// 保存メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get menu_save;

  /// スタックを閉じるメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'スタックを閉じる'**
  String get menu_close_stack;

  /// スタック情報表示メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'スタック情報を表示...'**
  String get menu_stack_info;

  /// Finderで表示メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'Finderで表示'**
  String get menu_show_in_finder;

  /// ページ設定メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'ページ設定...'**
  String get menu_page_setup;

  /// 印刷メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'印刷...'**
  String get menu_print;

  /// 取り消しメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'取り消す'**
  String get menu_undo;

  /// やり直しメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'やり直す'**
  String get menu_redo;

  /// 切り取りメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'切り取り'**
  String get menu_cut;

  /// コピーメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'コピー'**
  String get menu_copy;

  /// 貼り付けメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'貼り付け'**
  String get menu_paste;

  /// すべて選択メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'すべて選択'**
  String get menu_select_all;

  /// 検索メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'検索...'**
  String get menu_find;

  /// 置換メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'置換...'**
  String get menu_replace;

  /// スペルと文法メニュー
  ///
  /// In ja, this message translates to:
  /// **'スペルと文法'**
  String get menu_spelling_grammar;

  /// スペルと文法を表示メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'スペルと文法を表示'**
  String get menu_show_spelling_grammar;

  /// 入力中スペルチェックメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'書類の入力中にスペルをチェック'**
  String get menu_check_spelling_while_typing;

  /// 置換メニュー
  ///
  /// In ja, this message translates to:
  /// **'置換'**
  String get menu_substitutions;

  /// スマート置換メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'スマート置換'**
  String get menu_smart_substitutions;

  /// スマート引用符メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'スマート引用符'**
  String get menu_smart_quotes;

  /// スマートダッシュメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'スマートダッシュ'**
  String get menu_smart_dashes;

  /// 変換メニュー
  ///
  /// In ja, this message translates to:
  /// **'変換'**
  String get menu_transformations;

  /// 大文字変換メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'大文字に'**
  String get menu_make_uppercase;

  /// 小文字変換メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'小文字に'**
  String get menu_make_lowercase;

  /// 先頭大文字変換メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'先頭を大文字に'**
  String get menu_capitalize;

  /// パスファインダーメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'パスファインダー...'**
  String get menu_pathfinder;

  /// バックグラウンドタスクメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'バックグラウンドタスク...'**
  String get menu_background_tasks;

  /// サイドバー表示切り替えメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'サイドバーを表示/隠す'**
  String get menu_show_hide_sidebar;

  /// 詳細パネル表示切り替えメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'詳細パネルを表示/隠す'**
  String get menu_show_hide_detail_panel;

  /// ツールバー表示切り替えメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'ツールバーを表示/隠す'**
  String get menu_show_hide_toolbar;

  /// グラフビューメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'グラフビュー'**
  String get menu_graph_view;

  /// テーブルビューメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'テーブルビュー'**
  String get menu_table_view;

  /// 拡大メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'拡大'**
  String get menu_zoom_in;

  /// 縮小メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'縮小'**
  String get menu_zoom_out;

  /// 実際のサイズメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'実際のサイズ'**
  String get menu_actual_size;

  /// 全画面表示メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'全画面表示'**
  String get menu_fullscreen;

  /// テーマカラーメニュー
  ///
  /// In ja, this message translates to:
  /// **'テーマカラー'**
  String get menu_theme_color;

  /// ノード作成メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'ノードを作成'**
  String get menu_create_node;

  /// リンク作成メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'リンクを作成'**
  String get menu_create_link;

  /// プロパティ編集メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'プロパティを編集'**
  String get menu_edit_properties;

  /// ブックマーク追加メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'ブックマークに追加'**
  String get menu_add_bookmark;

  /// ブックマーク管理メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'ブックマークを管理...'**
  String get menu_manage_bookmarks;

  /// チャート画像保存メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'チャートを画像で保存...'**
  String get menu_save_chart_as_image;

  /// 削除メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get menu_delete;

  /// RinneGraphヘルプメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'RinneGraphヘルプ'**
  String get menu_app_help;

  /// ようこそメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'ようこそ'**
  String get menu_welcome;

  /// アップデート確認メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'Check for updates...'**
  String get menu_check_updates;

  /// リリースノートメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'リリースノート'**
  String get menu_release_notes;

  /// キーボードショートカットメニュー項目
  ///
  /// In ja, this message translates to:
  /// **'キーボードショートカット'**
  String get menu_keyboard_shortcuts;

  /// フィードバック送信メニュー項目
  ///
  /// In ja, this message translates to:
  /// **'フィードバックを送信'**
  String get menu_send_feedback;

  /// 言語設定画面のタイトル
  ///
  /// In ja, this message translates to:
  /// **'言語設定'**
  String get settings_language_title;

  /// デモ画面のタイトル
  ///
  /// In ja, this message translates to:
  /// **'ローカライズデモ'**
  String get demo_title;

  /// デモ画面の説明文
  ///
  /// In ja, this message translates to:
  /// **'このデモでは、RinneGraphアプリケーションのローカライズ機能を確認できます。'**
  String get demo_description;

  /// 言語切り替えセクションのタイトル
  ///
  /// In ja, this message translates to:
  /// **'言語切り替え'**
  String get demo_language_switch;

  /// 共通ボタンセクションのタイトル
  ///
  /// In ja, this message translates to:
  /// **'共通ボタン'**
  String get demo_common_buttons;

  /// RinneGraph概念セクションのタイトル
  ///
  /// In ja, this message translates to:
  /// **'RinneGraph概念'**
  String get demo_app_concepts;

  /// データベース用語セクションのタイトル
  ///
  /// In ja, this message translates to:
  /// **'データベース用語'**
  String get demo_database_terms;

  /// エラーメッセージセクションのタイトル
  ///
  /// In ja, this message translates to:
  /// **'エラーメッセージ'**
  String get demo_error_messages;

  /// アクティビティバー：グラフナビゲーション画面
  ///
  /// In ja, this message translates to:
  /// **'グラフナビゲーション'**
  String get activity_graph_navigation;

  /// アクティビティバー：高度な検索
  ///
  /// In ja, this message translates to:
  /// **'高度な検索'**
  String get activity_advanced_search;

  /// アクティビティバー：設定画面
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get activity_settings;

  /// アクティビティバー：スタックコレクション画面
  ///
  /// In ja, this message translates to:
  /// **'スタックコレクション'**
  String get activity_stack_collection;

  /// アクティビティバー：エンティティエディタ画面
  ///
  /// In ja, this message translates to:
  /// **'エンティティエディタ'**
  String get activity_entity_editor;

  /// アクティビティバー：ウェルカム画面
  ///
  /// In ja, this message translates to:
  /// **'ウェルカム'**
  String get activity_welcome;

  /// アクティビティバー：ラベル一覧
  ///
  /// In ja, this message translates to:
  /// **'ラベル一覧'**
  String get activity_label_list;

  /// アクティビティバー：プロパティ一覧
  ///
  /// In ja, this message translates to:
  /// **'プロパティ一覧'**
  String get activity_property_list;

  /// アクティビティバー：AIテスト画面
  ///
  /// In ja, this message translates to:
  /// **'AIテスト'**
  String get activity_ai_test;

  /// スクリーンショット：グラフナビゲーション画面の説明
  ///
  /// In ja, this message translates to:
  /// **'グラフナビゲーション画面'**
  String get screenshot_graph_navigation;

  /// スクリーンショット：設定画面の説明
  ///
  /// In ja, this message translates to:
  /// **'設定画面（ダイアログ）'**
  String get screenshot_settings_dialog;

  /// スクリーンショット：スタックコレクション画面の説明
  ///
  /// In ja, this message translates to:
  /// **'スタックコレクション画面'**
  String get screenshot_stack_collection;

  /// スクリーンショット：エンティティエディタ画面の説明
  ///
  /// In ja, this message translates to:
  /// **'エンティティエディタ画面'**
  String get screenshot_entity_editor;

  /// スクリーンショット：ウェルカム画面の説明
  ///
  /// In ja, this message translates to:
  /// **'ウェルカム画面'**
  String get screenshot_welcome;

  /// スクリーンショット：メタデータ管理画面の説明
  ///
  /// In ja, this message translates to:
  /// **'メタデータ管理画面'**
  String get screenshot_metadata_editor;

  /// スクリーンショット：バックグラウンドタスクテスト画面の説明
  ///
  /// In ja, this message translates to:
  /// **'バックグラウンドタスクテスト画面'**
  String get screenshot_background_tasks;

  /// CSVインポート：ファイルが空の場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'CSVファイルが空です'**
  String get error_csv_empty;

  /// CSVインポート：データ行がない場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'データ行がありません'**
  String get error_csv_no_data;

  /// CSVインポート：ノード作成時のエラー
  ///
  /// In ja, this message translates to:
  /// **'ノード作成エラー'**
  String get error_csv_node_creation;

  /// CSVインポート：リンク作成時のエラー
  ///
  /// In ja, this message translates to:
  /// **'リンク作成エラー'**
  String get error_csv_link_creation;

  /// CSVインポート：マッピング設定が不正な場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'CSVマッピング設定が不正です。ノードまたはリンクの設定が必要です。'**
  String get error_csv_invalid_mapping;

  /// CSVインポート：一般的なインポートエラー
  ///
  /// In ja, this message translates to:
  /// **'インポート中にエラーが発生しました'**
  String get error_csv_import_failed;

  /// CSVインポート：IDカラムが見つからない場合のエラー
  ///
  /// In ja, this message translates to:
  /// **'IDカラムが見つかりません'**
  String get error_id_column_not_found;

  /// コマンド：ウェルカムダイアログが閉じられるまで待機
  ///
  /// In ja, this message translates to:
  /// **'ウェルカムが閉じられるまで待機'**
  String get command_welcome_wait_closed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
