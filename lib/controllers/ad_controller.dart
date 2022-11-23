import 'dart:io';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/controllers/user_controller.dart';
import 'package:flutter_todo/models/ad_model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const int maxFailedLoadAttempts = 3;

class AdState extends StateNotifier<AdModel> {
  AdState(this._ref) : super(const AdModel(numRewardedLoadAttempts: 3));
  final Ref _ref;

  static final provider =
      StateNotifierProvider<AdState, AdModel>((ref) => AdState(ref));

  final AdRequest request = const AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/5224354917'
            : 'ca-app-pub-3940256099942544/1712485313',
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            log('$ad loaded.');
            state = state.copyWith(rewardedAd: ad, numRewardedLoadAttempts: 0);
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('RewardedAd failed to load: $error');
            state = state.copyWith(
              rewardedAd: null,
              numRewardedLoadAttempts: state.numRewardedLoadAttempts + 1,
            );
            if (state.numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {
    if (state.rewardedAd == null) {
      log('Warning: attempt to show rewarded before loaded.');
    }
    state.rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          log('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    state.rewardedAd!.setImmersiveMode(true);
    state.rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      log('$ad user rewarded!');
      _ref.read(UserController.provider).addPoints();
    });
    state = state.copyWith(rewardedAd: null);
  }
}

class AdController {
  AdController(this._ref);

  static final provider = Provider.autoDispose((ref) => AdController(ref));

  final Ref _ref;
  createAd() {
    _ref.read(AdState.provider.notifier)._createRewardedAd();
  }

  showAd() {
    _ref.read(AdState.provider.notifier)._showRewardedAd();
  }
}
