// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyAdModel {
  final RewardedAd? rewardedAd;
  final int numRewardedLoadAttempts;
  const MyAdModel({
    this.rewardedAd,
    this.numRewardedLoadAttempts = 0,
  });

  bool get isAdLoaded => rewardedAd != null;

  MyAdModel copyWith({
    RewardedAd? rewardedAd,
    int? numRewardedLoadAttempts,
  }) {
    return MyAdModel(
      rewardedAd: rewardedAd,
      numRewardedLoadAttempts:
          numRewardedLoadAttempts ?? this.numRewardedLoadAttempts,
    );
  }
}
