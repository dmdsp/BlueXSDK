//
//  ALDomobMediationAdapter.m
//  DomobSDK
//
//  Created by 刘士林 on 2025/4/2.
//

#import "ALDomobMediationAdapter.h"
#import <DomobAdSDK/DMAds.h>
#import <DomobAdSDK/DM_BannerAd.h>
#import <DomobAdSDK/DM_BannerView.h>

#import <DomobAdSDK/DM_RewardVideoAd.h>

#define ADAPTER_VERSION @"1.0.0"

@interface ALDomobMediationAdapterAdViewDelegate : NSObject <DMBannerAdDelegate>
@property (nonatomic,   weak) ALDomobMediationAdapter *parentAdapter;
@property (nonatomic, strong) id<MAAdViewAdapterDelegate> delegate;
- (instancetype)initWithParentAdapter:(ALDomobMediationAdapter *)parentAdapter andNotify:(id<MAAdViewAdapterDelegate>)delegate;
@end

@interface ALDomobRewardedVideoAdDelegate : NSObject <DMRewardVideoAdDelegate>
@property (nonatomic,   weak) ALDomobMediationAdapter *parentAdapter;
@property (nonatomic, strong) id<MARewardedAdapterDelegate> delegate;
- (instancetype)initWithParentAdapter:(ALDomobMediationAdapter *)parentAdapter andNotify:(id<MARewardedAdapterDelegate>)delegate;
@end

@interface ALDomobMediationAdapter ()

@property (nonatomic,   copy, nullable) NSString *adViewPlacementIdentifier;
@property (nonatomic,   copy, nullable) NSString *rewardedPlacementIdentifier;

@property (nonatomic, strong) ALDomobMediationAdapterAdViewDelegate *adViewAdapterDelegate;
@property (nonatomic, strong) DM_BannerAd *biddingBannerAd;

@property (nonatomic, strong) ALDomobRewardedVideoAdDelegate *rewardedVideoAdDelegate;
@property (nonatomic, strong) DM_RewardVideoAd *rewardVideoAd;
@end

@implementation ALDomobMediationAdapter

#pragma mark - MAAdapter Methods

- (void)initializeWithParameters:(id<MAAdapterInitializationParameters>)parameters
               completionHandler:(void (^)(MAAdapterInitializationStatus, NSString * _Nullable))completionHandler
{
    NSString *appId = [parameters.serverParameters al_stringForKey: @"app_id"];
    [self log: @"Initializing Domob SDK with app ID: %@...", appId];
    
    // 初始化Domob SDK
    [[DMAds shareInstance] initSDKWithAppId:appId];
    
    // 注册为信号提供者
    completionHandler(MAAdapterInitializationStatusInitializedSuccess, nil);
}

- (NSString *)SDKVersion
{
    return [[DMAds shareInstance] getSdkVersion];
}

- (NSString *)adapterVersion
{
    return ADAPTER_VERSION;
}
- (void)destroy
{
    [self log: @"Destroying..."];
    
    self.rewardVideoAd = nil;
    self.rewardedVideoAdDelegate.delegate = nil;
    self.rewardedVideoAdDelegate = nil;
    
    self.biddingBannerAd = nil;
    self.adViewAdapterDelegate.delegate = nil;
    self.adViewAdapterDelegate = nil;
}
#pragma mark - MASignalProvider

- (void)collectSignalWithParameters:(id<MASignalCollectionParameters>)parameters
                         andNotify:(id<MASignalCollectionDelegate>)delegate
{
    [self log: @"Collecting signal..."];
    
    // 生成信号
    NSString *signal = [self generateBiddingSignal];
    [delegate didCollectSignal: signal];
}

- (NSString *)generateBiddingSignal
{
    // 生成竞价信号
    return [NSString stringWithFormat:@"{\"slotID\":\"%@\",\"bidPrice\":%d}", self.adViewPlacementIdentifier ?: @"", 0];
}

#pragma mark - MAAdViewAdapter Methods

- (void)loadAdViewAdForParameters:(id<MAAdapterResponseParameters>)parameters
                         adFormat:(MAAdFormat *)adFormat
                        andNotify:(id<MAAdViewAdapterDelegate>)delegate
{
    NSString *instanceID = parameters.thirdPartyAdPlacementIdentifier;
    NSString *bidResponse = parameters.bidResponse;
    BOOL isBiddingAd = [bidResponse al_isValidString];
    [self log: @"Loading Domob %@banner ad for instance ID: %@", (isBiddingAd ? @"bidding " : @""), instanceID];
        
    if (isBiddingAd) {
        // 处理竞价广告加载
        self.adViewPlacementIdentifier = instanceID;
        self.adViewAdapterDelegate = [[ALDomobMediationAdapterAdViewDelegate alloc] initWithParentAdapter:self andNotify:delegate];
        
        // 使用竞价响应加载广告
        self.biddingBannerAd = [[DM_BannerAd new] loadBannerAdTemplateAdWithSlotID:instanceID delegate:self.adViewAdapterDelegate];
    } else {
        // 处理普通广告加载
        self.adViewPlacementIdentifier = instanceID;
        self.adViewAdapterDelegate = [[ALDomobMediationAdapterAdViewDelegate alloc] initWithParentAdapter:self andNotify:delegate];
        
        // 缓存普通广告
        self.biddingBannerAd = [[DM_BannerAd new] loadBannerAdTemplateAdWithSlotID:instanceID delegate:self.adViewAdapterDelegate];
    }
}

- (void)loadRewardedAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MARewardedAdapterDelegate>)delegate
{
    NSString *instanceID = parameters.thirdPartyAdPlacementIdentifier;
    NSString *bidResponse = parameters.bidResponse;
    BOOL isBiddingAd = [bidResponse al_isValidString];
    
    [self log: @"Loading Domob %@rewarded ad for instance ID: %@", (isBiddingAd ? @"bidding " : @""), instanceID];

    if (isBiddingAd) {
        // 处理竞价广告加载
        self.rewardedPlacementIdentifier = instanceID;
        self.rewardedVideoAdDelegate = [[ALDomobRewardedVideoAdDelegate alloc] initWithParentAdapter:self andNotify:delegate];
        
        // 使用竞价响应加载广告
     
        self.rewardVideoAd = [[DM_RewardVideoAd new] loadRewardVideoAdTemplateAdWithSlotID:instanceID   delegate:self.rewardedVideoAdDelegate];
    } else {
        self.rewardedPlacementIdentifier = instanceID;
        self.rewardedVideoAdDelegate = [[ALDomobRewardedVideoAdDelegate alloc] initWithParentAdapter:self andNotify:delegate];
        
        // 使用竞价响应加载广告
    
        self.rewardVideoAd = [[DM_RewardVideoAd new] loadRewardVideoAdTemplateAdWithSlotID:instanceID  delegate:self.rewardedVideoAdDelegate];
    }
}

- (void)showRewardedAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MARewardedAdapterDelegate>)delegate
{
    [self log: @"Showing rewarded ad..."];
    // Configure reward from server.
    [self configureRewardForParameters: parameters];
    
    UIViewController *presentingViewController = parameters.presentingViewController ?: [ALUtils topViewControllerFromKeyWindow];
    [self.rewardVideoAd showRewardVideoViewInRootViewController:presentingViewController];
}
@end

@implementation ALDomobMediationAdapterAdViewDelegate

- (instancetype)initWithParentAdapter:(ALDomobMediationAdapter *)parentAdapter andNotify:(id<MAAdViewAdapterDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.parentAdapter = parentAdapter;
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - DMBannerAdDelegate

- (void)bannerAdDidLoad:(DM_BannerAd *)bannerAd
{
    [self.parentAdapter log: @"Banner ad loaded for instance ID: %@", bannerAd.slotID];
    
    // 保存广告实例
    self.parentAdapter.biddingBannerAd = bannerAd;
    
    // 获取价格和创意ID
        NSMutableDictionary *extraInfo = [NSMutableDictionary dictionary];
        if (bannerAd.bidPrice > 0) {
            extraInfo[@"revenue"] = @(bannerAd.bidPrice);
        }
    
    // 上报广告加载成功
    [self.delegate didLoadAdForAdView:bannerAd.bannerView withExtraInfo:extraInfo];
}

- (void)bannerAdDidFailToLoadWithError:(nonnull NSError *)error {
    [self.parentAdapter log: @"Banner ad failed to load with error: %@", error];
    [self.delegate didFailToLoadAdViewAdWithError:[MAAdapterError errorWithCode:error.code errorString:error.localizedDescription]];
}

- (void)bannerAdDidClick:(DM_BannerAd *)bannerAd
{
    [self.parentAdapter log: @"Banner ad clicked for instance ID: %@", bannerAd.slotID];
    [self.delegate didClickAdViewAd];
}

- (void)bannerAdDidShow:(DM_BannerAd *)bannerAd
{
    [self.parentAdapter log: @"Banner ad shown for instance ID: %@", bannerAd.slotID];
    [self.delegate didDisplayAdViewAd];
}

- (void)bannerAdDidClose:(nonnull DM_BannerAd *)bannerAd { 
    
}
@end


@implementation ALDomobRewardedVideoAdDelegate

- (instancetype)initWithParentAdapter:(ALDomobMediationAdapter *)parentAdapter andNotify:(id<MARewardedAdapterDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.parentAdapter = parentAdapter;
        self.delegate = delegate;
    }
    return self;
}
#pragma  ---DMRewardVideoAdDelegate
- (void)rewardVideoAdDidClick:(nonnull DM_RewardVideoAd *)rewardVideoAd {
    [self.parentAdapter log: @"Rewarded ad clicked"];
    [self.delegate didClickRewardedAd];
}
- (void)rewardVideoAdDidFailToLoadWithError:(nonnull NSError *)error {
    
    MAAdapterError *adapterError = MAAdapterError.noFill;
    [self.parentAdapter log: @"Rewarded ad failed to load with error: %@", adapterError];
    [self.delegate didFailToLoadRewardedAdWithError: adapterError];
}

- (void)rewardVideoAdDidFailToRenderWithError:(nonnull NSError *)error {
    MAAdapterError *adapterError = MAAdapterError.noFill;
    [self.parentAdapter log: @"Rewarded ad failed to load with error: %@", adapterError];
    [self.delegate didFailToLoadRewardedAdWithError: adapterError];
}

- (void)rewardVideoAdDidLoad:(nonnull DM_RewardVideoAd *)rewardVideoAd {
    
    [self.parentAdapter log: @"Rewarded ad loaded: %@", rewardVideoAd.slotID];
    
    // 保存广告实例
    self.parentAdapter.rewardVideoAd = rewardVideoAd;
    
    // 获取价格和创意ID
        NSMutableDictionary *extraInfo = [NSMutableDictionary dictionary];
        if (rewardVideoAd.bidPrice > 0) {
            extraInfo[@"revenue"] = @(rewardVideoAd.bidPrice);
        }
    
    // 上报广告加载成功
    [self.delegate didLoadRewardedAdWithExtraInfo: extraInfo];
}

- (void)rewardVideoAdDidRender:(nonnull DM_RewardVideoAd *)rewardVideoAd {
   
}

- (void)rewardVideoAdDidShow:(nonnull DM_RewardVideoAd *)rewardVideoAd {
    [self.parentAdapter log: @"Rewarded ad shown"];
    [self.delegate didDisplayRewardedAd];
}
/// 广告被关闭
- (void)rewardVideoAdDidClose:(DM_RewardVideoAd *)rewardVideoAd{
    [self.parentAdapter log: @"Rewarded ad will close"];
    [self.delegate didHideRewardedAd];

}
- (void)rewardVideoAdDidComplete:(DM_RewardVideoAd *)rewardVideoAd{
    [self.parentAdapter log: @"Rewarded ad finished"];
    MAReward * reward = [MAReward reward];
    [self.delegate didRewardUserWithReward:reward];
}
///播放失败的回调
- (void)rewardVideoAdDidFailToShowWithError:(NSError *)error{
  
}

///视频播放完成
- (void)rewardVideoAdPlayToEndTime:(DM_RewardVideoAd *)rewardVideoAd{
    [self.parentAdapter log: @"Rewarded ad finished"];
}
@end
