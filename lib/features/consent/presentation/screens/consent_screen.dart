import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/consent_providers.dart';

class ConsentScreen extends ConsumerStatefulWidget {
  final VoidCallback? onComplete;

  const ConsentScreen({super.key, this.onComplete});

  @override
  ConsumerState<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends ConsumerState<ConsentScreen> {
  bool _analyticsConsent = false;
  bool _personalizedAdsConsent = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // App Logo
              Icon(
                Icons.account_balance_wallet,
                size: 80,
                color: const Color(0xFF00897B), // Teal color
              ),
              const SizedBox(height: 16),
              // App Name
              Text(
                'TripWallet',
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00897B),
                ),
              ),
              const SizedBox(height: 8),
              // Welcome Message
              Text(
                'Welcome to TripWallet',
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
                  fontSize: 18,
                  color: theme.colorScheme.onSurface.withAlpha(178),
                ),
              ),
              const SizedBox(height: 40),
              // Data Collection Explanation
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data Collection & Privacy',
                        style: GoogleFonts.lexend(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'What we collect:',
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildBulletPoint('Trip and expense data (stored locally)'),
                      _buildBulletPoint('App usage analytics (optional)'),
                      _buildBulletPoint('Device information for crash reports'),
                      const SizedBox(height: 12),
                      Text(
                        'What we DO NOT collect:',
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildBulletPoint('Personal identification data'),
                      _buildBulletPoint('Financial account information'),
                      _buildBulletPoint('Location tracking'),
                      const SizedBox(height: 16),
                      // Privacy Policy Link
                      InkWell(
                        onTap: () {
                          // TODO: Launch privacy policy URL
                          // Will be implemented by W4 with url_launcher
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.open_in_new,
                              size: 16,
                              color: const Color(0xFF00897B),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Privacy Policy',
                              style: GoogleFonts.lexend(
                                fontSize: 14,
                                color: const Color(0xFF00897B),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Consent Checkboxes
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CheckboxListTile(
                      value: _analyticsConsent,
                      onChanged: (value) {
                        setState(() {
                          _analyticsConsent = value ?? false;
                        });
                      },
                      title: Text(
                        'Analytics',
                        style: GoogleFonts.lexend(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Help us improve the app by sharing anonymous usage data',
                        style: GoogleFonts.lexend(fontSize: 12),
                      ),
                      activeColor: const Color(0xFF00897B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const Divider(height: 1),
                    CheckboxListTile(
                      value: _personalizedAdsConsent,
                      onChanged: (value) {
                        setState(() {
                          _personalizedAdsConsent = value ?? false;
                        });
                      },
                      title: Text(
                        'Personalized Ads',
                        style: GoogleFonts.lexend(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'See ads tailored to your interests${Platform.isIOS ? ' (requires ATT permission)' : ''}',
                        style: GoogleFonts.lexend(fontSize: 12),
                      ),
                      activeColor: const Color(0xFF00897B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Action Buttons
              ElevatedButton(
                onPressed: _handleAcceptAll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Accept All',
                  style: GoogleFonts.lexend(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _handleAcceptSelected,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF00897B),
                  side: const BorderSide(color: Color(0xFF00897B)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Accept Selected',
                  style: GoogleFonts.lexend(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _handleContinueWithout,
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurface.withAlpha(153),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Continue Without Consent',
                  style: GoogleFonts.lexend(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: GoogleFonts.lexend(fontSize: 14),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lexend(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAcceptAll() async {
    setState(() {
      _analyticsConsent = true;
      _personalizedAdsConsent = true;
    });
    await _saveConsentAndNavigate();
  }

  Future<void> _handleAcceptSelected() async {
    await _saveConsentAndNavigate();
  }

  Future<void> _handleContinueWithout() async {
    setState(() {
      _analyticsConsent = false;
      _personalizedAdsConsent = false;
    });
    await _saveConsentAndNavigate();
  }

  Future<void> _saveConsentAndNavigate() async {
    try {
      // Save consent via provider
      await ref.read(consentNotifierProvider.notifier).saveConsent(
            analyticsConsent: _analyticsConsent,
            personalizedAdsConsent: _personalizedAdsConsent,
          );

      if (!mounted) return;

      // Navigate to onboarding or home
      widget.onComplete?.call();
    } catch (e) {
      if (!mounted) return;

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save consent: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
