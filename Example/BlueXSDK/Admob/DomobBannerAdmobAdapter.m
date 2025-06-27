//
//  DomobBannerAdmobAdapter.m
//  DomobSDK
//
//  Created by 刘士林 on 2025/6/10.
//

#import "DomobBannerAdmobAdapter.h"
#import <DomobAdSDK/DM_BannerAd.h>
#import <DomobAdSDK/DM_BannerView.h>
#import <stdatomic.h>
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface DomobBannerAdmobAdapter () <DMBannerAdDelegate, GADMediationBannerAd>

@property (nonatomic, strong) DM_BannerAd *bannerAd;
@property (nonatomic, strong) UIView *bannerView;
@property (nonatomic, copy) GADMediationBannerLoadCompletionHandler loadCompletionHandler;
@property (nonatomic, weak) id<GADMediationBannerAdEventDelegate> adEventDelegate;

@end

@implementation DomobBannerAdmobAdapter

#pragma mark - GADMediationAdapter

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration
                   completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationBannerLoadCompletionHandler originalCompletionHandler = [completionHandler copy];

    self.loadCompletionHandler = ^id<GADMediationBannerAdEventDelegate>(id<GADMediationBannerAd> _Nullable ad, NSError *_Nullable error) {
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
        }
        id<GADMediationBannerAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
            delegate = originalCompletionHandler(ad, error);
        }
        originalCompletionHandler = nil;
        return delegate;
    };

    NSString *slotID = adConfiguration.credentials.settings[@"parameter"];
    CGSize adSize = adConfiguration.adSize.size;

    self.bannerAd = [[DM_BannerAd alloc] init];
    // 这里的ViewSize320x50可以根据adSize适配
    [self.bannerAd loadBannerAdTemplateAdWithSlotID:slotID  delegate:self];
}

#pragma mark - GADMediationBannerAd

- (UIView *)view {
    return self.bannerView;
}

#pragma mark - DMBannerAdDelegate
- (void)bannerAdDidLoad:(DM_BannerAd *)bannerAd {
    self.bannerView = self.bannerAd.bannerView;
    if (self.loadCompletionHandler) {
        self.adEventDelegate = self.loadCompletionHandler(self, nil);
        self.loadCompletionHandler = nil;
    }
}

- (void)bannerAdDidFailToLoadWithError:(NSError *)error {
    if (self.loadCompletionHandler) {
        self.adEventDelegate = self.loadCompletionHandler(nil, error);
        self.loadCompletionHandler = nil;
    }
}

- (void)bannerAdDidShow:(DM_BannerAd *)bannerAd {
    [self.adEventDelegate willPresentFullScreenView];
}

- (void)bannerAdDidClick:(DM_BannerAd *)bannerAd {
    [self.adEventDelegate reportClick];
}

- (void)bannerAdDidClose:(DM_BannerAd *)bannerAd {
    [self.adEventDelegate didDismissFullScreenView];
}

@end

NS_ASSUME_NONNULL_END
