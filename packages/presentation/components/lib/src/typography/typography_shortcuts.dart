import 'package:flutter/material.dart';
import 'package:presentation_components/src/typography/app_text.dart';

/// Shortcut widgets for text elements.
///
/// Provides shortcut widgets for frequently used AppTextVariants.
/// This simplifies the specification of variants and improves code readability.

// Content text related shortcuts

/// Large heading (content area)
class Heading1Text extends StatelessWidget {
  const Heading1Text(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.textHeading1, color: color);
  }
}

/// Medium heading (content area)
class Heading2Text extends StatelessWidget {
  const Heading2Text(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.textHeading2, color: color);
  }
}

/// Small heading (content area)
class Heading3Text extends StatelessWidget {
  const Heading3Text(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.textHeading3, color: color);
  }
}

/// Body (content area)
class BodyText extends StatelessWidget {
  const BodyText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.textBody, color: color);
  }
}

/// Caption (content area)
class CaptionText extends StatelessWidget {
  const CaptionText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.textCaption, color: color);
  }
}

/// Supplementary text (content area)
class SmallText extends StatelessWidget {
  const SmallText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.textSmall, color: color);
  }
}

// UI related shortcuts

/// Large heading (UI component)
class UiHeading1Text extends StatelessWidget {
  const UiHeading1Text(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.pageTitle, color: color);
  }
}

/// Medium heading (UI component)
class UiHeading2Text extends StatelessWidget {
  const UiHeading2Text(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.sectionTitle, color: color);
  }
}

/// Small heading (UI component)
class UiHeading3Text extends StatelessWidget {
  const UiHeading3Text(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.itemTitle, color: color);
  }
}

/// Body text (UI component)
class UiBodyText extends StatelessWidget {
  const UiBodyText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.bodyText, color: color);
  }
}

/// Caption (UI component)
class UiCaptionText extends StatelessWidget {
  const UiCaptionText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.captionText, color: color);
  }
}

/// Small text (UI component)
class UiSmallText extends StatelessWidget {
  const UiSmallText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.smallText, color: color);
  }
}

// Code block related shortcuts

/// Code block body
class CodeBlockText extends StatelessWidget {
  const CodeBlockText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.codeBlock, color: color);
  }
}

/// Inline code
class CodeInlineText extends StatelessWidget {
  const CodeInlineText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.codeInline, color: color);
  }
}

// Table related shortcuts

/// Table header
class TableHeaderText extends StatelessWidget {
  const TableHeaderText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.tableHeader, color: color);
  }
}

/// Table body
class TableBodyText extends StatelessWidget {
  const TableBodyText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.tableBody, color: color);
  }
}

/// Table footer
class TableFooterText extends StatelessWidget {
  const TableFooterText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.tableFooter, color: color);
  }
}

// Label related shortcuts (class name and variant name changed)

/// Primary label (graph node)
class EntityLabelPrimaryText extends StatelessWidget {
  const EntityLabelPrimaryText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(
      text,
      variant: AppTextVariant.entityLabelPrimary,
      color: color,
    );
  }
}

/// Secondary label (graph edge)
class EntityLabelSecondaryText extends StatelessWidget {
  const EntityLabelSecondaryText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(
      text,
      variant: AppTextVariant.entityLabelSecondary,
      color: color,
    );
  }
}

/// Metadata label
class EntityLabelMetaText extends StatelessWidget {
  const EntityLabelMetaText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppText(text, variant: AppTextVariant.entityLabelMeta, color: color);
  }
}
