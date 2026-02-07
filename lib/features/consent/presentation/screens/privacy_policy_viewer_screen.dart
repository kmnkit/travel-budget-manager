import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../widgets/privacy_policy_content.dart';

class PrivacyPolicyViewerScreen extends StatelessWidget {
  const PrivacyPolicyViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.consentViewFullPolicy),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: PrivacyPolicyContent(scrollable: true),
        ),
      ),
    );
  }
}
