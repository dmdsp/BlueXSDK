//
//  DomobBiddingDelegate.h
//  DMAd
//
//  Created by 刘士林 on 2024/9/6.
//

#import <Foundation/Foundation.h>
#import <DomobAdSDK/DM_SplashAd.h>
#import <DomobAdSDK/DM_BannerAd.h>
#import <DomobAdSDK/DM_BannerView.h>
#import <DomobAdSDK/DM_RewardVideoAd.h>
#import <DomobAdSDK/DM_NativeAd.h>

NS_ASSUME_NONNULL_BEGIN

@interface DomobBiddingDelegate : NSObject <DMSplashAdDelegate,DMBannerAdDelegate,DMRewardVideoAdDelegate,DMNativeAdLoadDelegate>
@property(nonatomic, strong)  NSString *unitID;

@end

NS_ASSUME_NONNULL_END
