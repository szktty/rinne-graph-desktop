# RinneGraph

[English](README.md)

[![CLA assistant](https://cla-assistant.io/readme/badge/szktty/rinne-graph-desktop)](https://cla-assistant.io/szktty/rinne-graph-desktop)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
[![Flutter](https://img.shields.io/badge/Flutter-3.41.2-blue?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Windows-lightgrey)](README.ja.md)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

![RinneGraph Screenshot](docs/images/screenshot.png)

**⚠️ 開発中 - アルファ版 ⚠️**

RinneGraph は、**ローカル・オフラインで動作するグラフベースの個人知識管理アプリ**です。グラフデータベースサーバーは不要で、プロパティグラフのデータモデルを使って個人の知識を管理・整理できます。情報の繋がりを直感的に可視化し、ナビゲートすることができます。

## 🚧 プロジェクト状況

**本プロジェクトはアルファ段階であり、現在も活発に開発中です。**

- ❌ **本番利用には対応していません**
- ❌ **機能は未完成で、期待通りに動作しない場合があります**
- ❌ **頻繁に破壊的変更が発生する可能性があります**
- ✅ **フィードバックおよびバグ報告は歓迎します**

**現在の注力点**: 早期フィードバック収集のための MVP（最小限のプロダクト）構築

## 🔍 他のツールとの違い

ObsidianやLogseqもグラフビューを備えていますが、その基盤となるデータモデルはあくまで**ファイル**です。グラフはドキュメント間のリンクを可視化したものに過ぎません。RinneGraph はアプローチが異なります。データモデルそのものがプロパティグラフであり、任意のエンティティをノード、任意の関係をエッジとして、それぞれに固有のプロパティを持たせることができます。この細かい粒度により、ドキュメントやアウトラインには収まらない知識も表現できます。

一方、Neo4jやArangoDBのような本格的なグラフDBはサーバープロセスが必要で、開発者向けに設計されています。RinneGraphはそのような表現力豊かなデータモデルを、**ローカル・オフライン・GUIファーストのデスクトップアプリ**として提供します。サーバー不要、面倒なセットアップも不要で、あなたのデータはあなたのデバイスの中だけに存在します。

## 💡 機能

- **ローカルファースト・オフライン対応** — 完全にデバイス上で動作し、グラフDBサーバーは不要
- グラフデータベース構造（ノードとリンク）で個人データを整理
- 情報間の関係を可視化
- データを効率よく検索・ナビゲート
- 自己完結した「スタック」（ポータブルなデータベース単位）でデータを管理

## 🚀 クイックスタート

### 前提条件

- Flutter 3.41.2 以上
- Dart 3.11.0 以上
- Melos（モノレポ管理ツール）

### 対応プラットフォーム

- ✅ **macOS**（メインサポート）
- ✅ **Windows**（実験的サポート）

**注意**: Windows サポートは実験的です。ビルド・起動はできますが、一部の機能が期待通りに動作しない場合があります。フィードバックをお待ちしています。

### セットアップ

```bash
# リポジトリをクローン
git clone https://github.com/szktty/rinne_graph_desktop.git
cd rinne_graph_desktop

# 依存関係のインストール（Melos によるモノレポ管理）
flutter pub get
melos bootstrap

# デスクトップアプリを起動
cd apps/desktop
flutter run -d macos  # または -d windows
```

### ビルド

```bash
# macOS
cd apps/desktop
flutter build macos

# Windows
cd apps/desktop
flutter build windows

# またはビルドスクリプトを使用（macOS のみ）
./scripts/build.sh
```

## 📚 ドキュメント

- [開発戦略](docs/strategy/governance/DEVELOPMENT_STRATEGY.md) — プロジェクトの開発方針とリリースサイクル
- [公開チェックリスト](docs/strategy/governance/PUBLISHING_CHECKLIST.md) — MVP リリース準備タスク

## 🐛 Issues の報告

本プロジェクトは開発初期段階にあります。バグを発見した場合や提案がある場合は：

1. 重複を避けるため、既存の [Issues](https://github.com/szktty/rinne-graph-desktop/issues) を確認してください
2. 以下の情報を含む新しい Issue を作成してください：
    - 再現手順
    - 期待される動作と実際の動作
    - 環境情報（OS、Flutter バージョンなど）

**注意**: 個人プロジェクトのため、返答までに時間がかかる場合があります。

## 📄 ライセンス

本プロジェクトは **GNU Affero General Public License v3.0 (AGPLv3)** のもとで公開しています。詳細は [LICENSE](LICENSE) ファイルを参照してください。

### コントリビューションと CLA

コントリビューションを歓迎します。プルリクエストを送信することで、[Contributor License Agreement (CLA)](https://gist.github.com/szktty/098a5717a813146dd797e557400a31c1) に同意したものとみなされます。詳細は [CONTRIBUTING.md](CONTRIBUTING.md) を参照してください。

### 商用ライセンス

AGPLv3 の制約（ネットワーク配信サービスにおけるソースコード公開義務など）を回避したい組織・個人向けに、将来的に**商用ライセンス**を提供予定です。

商用ライセンスへの関心やライセンスに関するお問い合わせは、下記までご連絡ください：

**contact@szktty.jp**
