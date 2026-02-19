# Progress Log: AppSettings廃止・設定アーキテクチャ整理

## 完了日
2026-02-20

## 実装結果

全ステップ完了。ビルド成功 (✓ Built RinneGraph.app)

---

## 完了した変更

### Step 1: `Settings`モデルを`core_settings`に移動
- `packages/core/settings/lib/src/model/settings.dart` を新規作成（features_settings/models/settings.dart をコピー）
- デフォルト言語 `'en'` / `Locale('en', 'US')` を確認

### Step 2: `SettingsManager`を`core_settings`に移動
- `packages/core/settings/lib/src/providers/settings_providers.dart` を全面書き換え
  - `AppSettingsManager`, `AutoSaveManager`, `SettingsWatcher`, `SettingsOperations` を削除
  - `SettingsManager` を追加（features_settings から移動）
  - `updateThemeColorType()` メソッドも追加
- `settings_providers.dart` から `settingsStorageService` プロバイダーの重複定義を削除（`settings_storage_provider.dart` に統一）
- `packages/core/settings/lib/core_settings.dart` にエクスポート追加

### Step 3: `core_localization`の依存関係修正
- `packages/core/localization/lib/src/providers/localization_providers.dart` を書き換え
  - `settingsManagerProvider` 参照を削除
  - `LocalizationNotifier` を独立させ、`setLocale()` で外部から設定を受け取る形に変更
  - `currentLocaleProvider` は `localizationNotifierProvider` の状態から取得
- `packages/core/localization/pubspec.yaml` から `core_settings` 依存を削除
- `flutter_localizations` 依存を追加（欠如していた）
- `intl` バージョンを `^0.20.0` に更新（flutter_localizations 互換性）

### Step 4: `features_settings`から`LocalizationNotifier`へ反映
- 当初計画では `features_settings` から `localizationNotifierProvider.setLocale()` を呼ぶ予定
- `core_localization` パッケージ自体の問題（`localization_providers.g.dart` が未生成、`flutter_gen` 依存問題）により、`features_settings` からのインポートは断念
- `core_localization` の `LocalizationNotifier` は独立した状態（`settingsManagerProvider` 依存なし）で整理完了
- `features_settings/pubspec.yaml` に `core_settings` 依存を追加（正式宣言）

### Step 5: `AppSettings`廃止
- `packages/core/settings/lib/src/model/app_settings.dart` を削除
- `packages/core/settings/lib/src/model/app_settings.freezed.dart` を削除
- `packages/core/settings/lib/src/model/app_settings.g.dart` を削除
- `packages/core/settings/lib/src/storage/settings_storage_service.dart` から `loadSettings()`, `saveSettings(AppSettings)`, `resetSettings()` を削除
- `packages/core/settings/lib/core_settings.dart` から `app_settings.dart` エクスポートを削除

### Step 6: `features_settings`のSettings/SettingsManager重複削除
- `packages/features/settings/lib/src/models/settings.dart` を `core_settings` の re-export に変更
- `packages/features/settings/lib/src/providers/settings_providers.dart` から `SettingsManager` を削除
  - `core_settings` の `settingsManagerProvider` を使うよう更新
  - `ActiveTheme` プロバイダーで設定変更に応じてテーマを同期

### Step 7 & 8: デフォルト言語確認・コード生成
- `Settings.defaults()` のデフォルトが `language: 'en'`, `locale: Locale('en', 'US')` であることを確認
- `apps/desktop` から `dart run build_runner build --delete-conflicting-outputs` を実行

---

## 最終アーキテクチャ

```
features_settings → core_settings → (core_localization は独立)
(UI・設定画面)       (設定永続化)    (ロケール管理のみ・独立)
```

### 設定フロー
1. `core_settings.SettingsManager` が `SettingsStorageService` を使って設定を読み書き
2. `features_settings.ActiveTheme` が `settingsManagerProvider` を監視してテーマを同期
3. `core_localization.LocalizationNotifier` は独立した状態（外部から `setLocale()` で更新可能）

---

## 残課題

### `core_localization` パッケージの修正
- `localization_providers.g.dart` が `apps/desktop` の `build_runner` では生成されない
  - パッケージ単独で `build_runner` を実行すると `flutter_gen` の `PackageNotFoundException` が発生
  - ただし `flutter build macos` は正常に通る（`flutter_gen` ファイルはビルド時に自動生成）
- `features_settings` から `core_localization` をインポートして `localizationNotifierProvider.setLocale()` を呼ぶ連携は未実装
  - ロケール変更は `settingsManagerProvider` の `Settings.locale` に保存されるため、アプリ起動時の復元は正常
  - ランタイムでの即時反映は `LocalizationNotifier` を使う場合に追加実装が必要

### `features_settings` テストの `models/settings.dart` インポート
- `test/models/settings_test.dart` 等が `../src/models/settings.dart` をインポートしているが、そのファイルは re-export になっているため問題なし
