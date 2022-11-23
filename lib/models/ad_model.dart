// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdModel {
  final RewardedAd? rewardedAd;
  final int numRewardedLoadAttempts;
  const AdModel({
    this.rewardedAd,
    required this.numRewardedLoadAttempts,
  });

  bool get isAdLoaded => rewardedAd != null;

  AdModel copyWith({
    RewardedAd? rewardedAd,
    int? numRewardedLoadAttempts,
  }) {
    return AdModel(
      rewardedAd: rewardedAd,
      numRewardedLoadAttempts:
          numRewardedLoadAttempts ?? this.numRewardedLoadAttempts,
    );
  }
}
