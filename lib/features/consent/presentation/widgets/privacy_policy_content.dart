import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicyContent extends StatefulWidget {
  final bool scrollable;

  const PrivacyPolicyContent({
    super.key,
    required this.scrollable,
  });

  @override
  State<PrivacyPolicyContent> createState() => _PrivacyPolicyContentState();
}

class _PrivacyPolicyContentState extends State<PrivacyPolicyContent> {
  String? _content;
  Locale? _currentLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);

    // Only reload if locale changed
    if (_currentLocale != locale) {
      _currentLocale = locale;
      _loadPrivacyPolicy();
    }
  }

  Future<void> _loadPrivacyPolicy() async {
    final locale = _currentLocale;
    final languageCode = locale?.languageCode ?? 'en';

    // Load appropriate asset based on locale
    final assetPath = languageCode == 'ko'
        ? 'assets/privacy-policy-ko.md'
        : 'assets/privacy-policy-en.md';

    try {
      final content = await rootBundle.loadString(assetPath);
      if (mounted) {
        setState(() {
          _content = content;
        });
      }
    } catch (e) {
      // Fallback to English if loading fails
      if (assetPath != 'assets/privacy-policy-en.md') {
        final fallbackContent = await rootBundle.loadString('assets/privacy-policy-en.md');
        if (mounted) {
          setState(() {
            _content = fallbackContent;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _content;

    if (content == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.scrollable) {
      return Markdown(
        data: content,
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          p: Theme.of(context).textTheme.bodyMedium,
          h2: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          h3: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      );
    } else {
      // Non-scrollable mode: wrap in container without scroll
      return Markdown(
        data: content,
        selectable: true,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        styleSheet: MarkdownStyleSheet(
          p: Theme.of(context).textTheme.bodyMedium,
          h2: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          h3: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      );
    }
  }
}
