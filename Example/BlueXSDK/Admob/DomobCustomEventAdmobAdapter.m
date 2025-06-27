//
//  DomobCustomEventAdmobAdapter.m
//  DomobSDK
//
//  Created by 刘士林 on 2025/6/12.
//

#import "DomobCustomEventAdmobAdapter.h"
#import <DomobAdSDK/DMAds.h>
#import "DomobBannerAdmobAdapter.h"
#import "DomobRewardVideoAdmobAdapter.h"
// #import "DomobInterstitialAdmobAdapter.h" // 如有插屏广告
// #import "DomobNativeAdmobAdapter.h"      // 如有原生广告
@interface DomobCustomEventAdmobAdapter ()
@property (nonatomic, strong) DomobBannerAdmobAdapter *bannerAdapter;
@property (nonatomic, strong) DomobRewardVideoAdmobAdapter *rewardedAdapter;
@end
@implementation DomobCustomEventAdmobAdapter

#pragma mark - GADMediationAdapter

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration
             completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 这里初始化你们的SDK
        [[DMAds shareInstance] initSDKWithAppId:@"1234"];
    });
    completionHandler(nil);
}

+ (GADVersionNumber)adSDKVersion {
    // 返回你们SDK的版本号
    GADVersionNumber version = {1, 0, 0}; // 示例
    return version;
}

+ (GADVersionNumber)adapterVersion {
    // 返回适配器版本号
    GADVersionNumber version = {1, 0, 0}; // 示例
    return version;
}

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return Nil;
}

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration
                   completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    self.bannerAdapter = [[DomobBannerAdmobAdapter alloc] init];
    [self.bannerAdapter loadBannerForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    self.rewardedAdapter = [[DomobRewardVideoAdmobAdapter alloc] init];
    [self.rewardedAdapter loadRewardedAdForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

// 如有插屏广告
/*
- (void)loadInterstitialForAdConfiguration:(GADMediationInterstitialAdConfiguration *)adConfiguration
                         completionHandler:(GADMediationInterstitialLoadCompletionHandler)completionHandler {
    DomobInterstitialAdmobAdapter *interstitialAdapter = [[DomobInterstitialAdmobAdapter alloc] init];
    [interstitialAdapter loadInterstitialForAdConfiguration:adConfiguration completionHandler:completionHandler];
}
*/

// 如有原生广告
/*
- (void)loadNativeAdForAdConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration
                     completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler {
    DomobNativeAdmobAdapter *nativeAdapter = [[DomobNativeAdmobAdapter alloc] init];
    [nativeAdapter loadNativeAdForAdConfiguration:adConfiguration completionHandler:completionHandler];
}
*/

@end
