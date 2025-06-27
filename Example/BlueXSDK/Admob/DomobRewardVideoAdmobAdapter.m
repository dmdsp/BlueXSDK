//
//  DomobRewardVideoAdmobAdapter.m
//  DomobSDK
//
//  Created by 刘士林 on 2025/6/10.
//

#import "DomobRewardVideoAdmobAdapter.h"
#import <DomobAdSDK/DMAds.h>
#import <DomobAdSDK/DM_RewardVideoAd.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <stdatomic.h>


@interface DomobRewardVideoAdmobAdapter () <DMRewardVideoAdDelegate, GADMediationRewardedAd>
@property (nonatomic, strong) DM_RewardVideoAd *rewardAd;
@property (nonatomic, copy) GADMediationRewardedLoadCompletionHandler loadCompletionHandler;
@property (nonatomic, weak) id<GADMediationRewardedAdEventDelegate> adEventDelegate;
@end

@implementation DomobRewardVideoAdmobAdapter

#pragma mark - GADMediationRewardedAd

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationRewardedLoadCompletionHandler originalCompletionHandler = [completionHandler copy];

    self.loadCompletionHandler = ^id<GADMediationRewardedAdEventDelegate>(id<GADMediationRewardedAd> _Nullable ad, NSError *_Nullable error) {
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
        }
        id<GADMediationRewardedAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
            delegate = originalCompletionHandler(ad, error);
        }
        originalCompletionHandler = nil;
        return delegate;
    };

    NSString *slotID = adConfiguration.credentials.settings[@"parameter"];
    self.rewardAd = [[DM_RewardVideoAd alloc] init];
    [self.rewardAd loadRewardVideoAdTemplateAdWithSlotID:slotID delegate:self];
}

#pragma mark - GADMediationRewardedAd

- (void)presentFromViewController:(UIViewController *)viewController {
    [self.rewardAd showRewardVideoViewInRootViewController:viewController];
}

#pragma mark - DMRewardVideoAdDelegate

- (void)rewardVideoAdDidLoad:(DM_RewardVideoAd *)rewardVideoAd {
    if (self.loadCompletionHandler) {
        self.adEventDelegate = self.loadCompletionHandler(self, nil);
        self.loadCompletionHandler = nil;
    }
}

- (void)rewardVideoAdDidFailToLoadWithError:(NSError *)error {
    if (self.loadCompletionHandler) {
        self.adEventDelegate = self.loadCompletionHandler(nil, error);
        self.loadCompletionHandler = nil;
    }
}

- (void)rewardVideoAdDidShow:(DM_RewardVideoAd *)rewardVideoAd {
    [self.adEventDelegate willPresentFullScreenView];
}

- (void)rewardVideoAdDidClick:(DM_RewardVideoAd *)rewardVideoAd {
    [self.adEventDelegate reportClick];
}

- (void)rewardVideoAdDidComplete:(DM_RewardVideoAd *)rewardVideoAd {
}

- (void)rewardVideoAdDidClose:(DM_RewardVideoAd *)rewardVideoAd {
    [self.adEventDelegate didDismissFullScreenView];
}

- (void)rewardVideoAdDidFailToShowWithError:(NSError *)error {
    [self.adEventDelegate didFailToPresentWithError:error];
}
///视频播放完成
- (void)rewardVideoAdPlayToEndTime:(DM_RewardVideoAd *)rewardVideoAd{
    [self.adEventDelegate didEndVideo];
}
@end
