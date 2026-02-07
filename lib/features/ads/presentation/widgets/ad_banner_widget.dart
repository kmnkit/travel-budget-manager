import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:trip_wallet/features/ads/presentation/providers/ad_providers.dart';
import 'package:trip_wallet/features/premium/presentation/providers/premium_providers.dart';

/// Widget that displays a banner ad
/// Only shows ads when user is not premium
class AdBannerWidget extends ConsumerStatefulWidget {
  const AdBannerWidget({super.key});

  @override
  ConsumerState<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends ConsumerState<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isLoading = false;

  Future<void> _loadBannerAd() async {
    if (_isLoading || _bannerAd != null) return;
    _isLoading = true;

    try {
      final bannerConfig =
          await ref.read(bannerAdConfigProvider.future);

      if (!bannerConfig.isEnabled || !mounted) return;

      final bannerAd = BannerAd(
        adUnitId: bannerConfig.unitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (mounted) {
              setState(() {
                _isAdLoaded = true;
              });
            }
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('AdBannerWidget: Failed to load ad: $error');
            ad.dispose();
            if (mounted) {
              setState(() {
                _isAdLoaded = false;
              });
            }
          },
        ),
      );

      await bannerAd.load();
      if (mounted) {
        setState(() {
          _bannerAd = bannerAd;
        });
      }
    } catch (e) {
      debugPrint('AdBannerWidget: Error loading banner ad: $e');
    } finally {
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowAds = ref.watch(shouldShowAdsProvider);

    if (!shouldShowAds) {
      return const SizedBox.shrink();
    }

    // Load ad reactively when shouldShowAds becomes true
    if (_bannerAd == null && !_isLoading) {
      _loadBannerAd();
    }

    if (!_isAdLoaded || _bannerAd == null) {
      return SizedBox(
        height: AdSize.banner.height.toDouble(),
      );
    }

    return SafeArea(
      top: false,
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
