import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../providers/ad_providers.dart';

/// A widget that displays a banner ad
class BannerAdWidget extends ConsumerStatefulWidget {
  final AdSize adSize;

  const BannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    final adRepo = ref.read(adRepositoryProvider);

    final ad = await adRepo.loadBannerAd(
      adSize: widget.adSize,
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        }
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      },
    );

    if (ad == null && mounted) {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ads if not already done
    ref.watch(adInitializerProvider);

    if (_hasError || !_isLoaded || _bannerAd == null) {
      // Return empty space with same height as ad would be
      return SizedBox(
        width: widget.adSize.width.toDouble(),
        height: widget.adSize.height.toDouble(),
      );
    }

    return SizedBox(
      width: widget.adSize.width.toDouble(),
      height: widget.adSize.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
