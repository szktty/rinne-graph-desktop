# RinneGraph

[English](README.md)

[![CLA assistant](https://cla-assistant.io/readme/badge/szktty/rinne-graph-desktop)](https://cla-assistant.io/szktty/rinne-graph-desktop)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
[![Flutter](https://img.shields.io/badge/Flutter-3.41.2-blue?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Windows-lightgrey)](README.ja.md)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

![RinneGraph Screenshot](docs/images/screenshot.png)

**⚠️ 開発中 - アルファ版 ⚠️**

![スクリーンショット](docs/images/screenshot.png)

## RinneGraphとは

RinneGraphは、アイデアをつなげてあなたの世界を形作るためのアプリです。データ間のつながりに焦点を当てて視覚化し、つながりのグラフを俯瞰することで新しいアイデアの地図が浮かび上がります。


## 進捗状況

**本プロジェクトはアルファ段階です。**

- ❌ **プロダクションの利用には適していません**
- ❌ **機能は未完成であり、期待通りに動作しない場合があります**
- ❌ **頻繁に破壊的変更が発生する可能性があります**
- ✅ **フィードバックおよびバグ報告を歓迎します**

## ドキュメントとノード

人気のある多くのアプリは、長文のテキストを基盤データとするドキュメント指向のデータベースです。ドキュメントは理解しやすく、扱いやすい概念です。データの保存先としてファイルと相性がよく、オフラインでのデータ管理やAIによる処理にも向いています。

しかし、ドキュメント指向のアプリでは、ユーザーの思考は長文のテキストに縛られざるを得ません。 ドキュメントは多くの情報を詰め込める構造化されたフォーマットであり、それぞれの情報（あるいは思考の断片）を個別に記述するのに向いていません。ドキュメント間のつながりを表現できるアプリは多いですが、漠然とした参照関係を表すハイパーリンクの域に留まります。

RinneGraphのアプローチは、ドキュメントよりも細かな粒度のノードでグラフを組み立てます。グラフは、任意の属性を持つノードと、ノード間のリンク（つながり）で構成されます。ノードの内容もリンクの内容もユーザーが自由に決めることができるため、ドキュメントでは表現しにくい細かな情報や自由な構造を表現できます。

RinneGraphではつながりこそ主体であり、百科事典を作るよりも頭脳の神経回路となるツールを目指しています。


## 機能

- **ローカルファースト・オフラインファースト** — 完全にオフラインで動作し、サーバーが不要です。
- **プロパティグラフ** — データベースはノードとリンクで構成されます。
- **グラフビュー** — ノード間のつながりを可視化します。
- **グラフの検索** — つながりをたどる検索が可能です。

## 対応プラットフォーム

- ✅ **macOS**（メインサポート）
- ✅ **Windows**（実験的サポート）

**注意**: Windows サポートは実験的です。ビルド・起動はできますが、一部の機能が期待通りに動作しない場合があります。フィードバックをお待ちしています。

## ダウンロード

最新のリリースを [リリースページ](https://github.com/szktty/rinne-graph-desktop/releases) からダウンロードしてください。


## ソースからビルド

### 前提条件

- Flutter 3.41.2 以上
- Dart 3.11.0 以上
- Melos（モノレポ管理ツール）

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
```

## 関連プロダクト

以下のプロダクトは主にRinneGraphのために開発したライブラリです。RinneGraphと並行して開発を行っています。

- **[Fonde UI](https://github.com/szktty/fonde-ui)** — デスクトップファーストの UI コンポーネント
- **[rinne_graph](https://github.com/szktty/rinne_graph)** — SQLite をバックエンドとする組み込みグラフデータベース
- **[plough](https://github.com/szktty/plough)** — ネットワークグラフ描画ライブラリ
- **[kiri_check](https://github.com/szktty/kiri_check)** — プロパティベーステストライブラリ


## 不具合などの報告

不具合を発見した場合や提案がある場合は、以下の手順に従ってイシューを作成してください。なお、返答に時間がかかる場合があります。

- 重複を避けるため、既存の [Issues](https://github.com/szktty/rinne-graph-desktop/issues) を確認してください。
- 不具合の報告の場合、以下の情報も追記してください。
    - 再現手順
    - 期待される動作と実際の動作
    - システム情報
      - RinneGraphのバージョン
      - OSのバージョン
      - （ソースコードからビルドした場合）Flutterのバージョン


## ライセンス

本プロジェクトはデュアルライセンスで提供しています：

- **[GNU Affero General Public License v3.0 (AGPLv3)](LICENSE)** — オープンソース利用向け
- **商用ライセンス** — AGPLv3 の制約なしに利用したい組織・個人向け（将来提供予定）

### コントリビューションと CLA

コントリビューションを歓迎します。プルリクエストを送信することで、[Contributor License Agreement (CLA)](https://gist.github.com/szktty/098a5717a813146dd797e557400a31c1) に同意したものとみなされます。詳細は [CONTRIBUTING.md](CONTRIBUTING.md) を参照してください。

### 商用ライセンス

AGPLv3 の制約（ネットワーク配信サービスにおけるソースコード公開義務など）を回避したい組織・個人向けに、将来的に**商用ライセンス**を提供予定です。

商用ライセンスへの関心やライセンスに関するお問い合わせは、下記までご連絡ください：

**contact@szktty.jp**

## 💖 スポンサー

RinneGraph は個人プロジェクトです。関心を持っていただけたら、[GitHub Sponsors](https://github.com/sponsors/szktty) でのご支援をいただけると助かります。開発継続の大きな励みになります。
