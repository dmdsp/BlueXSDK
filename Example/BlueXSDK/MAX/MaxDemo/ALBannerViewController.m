//
//  ALBannerViewController.m
//  DomobSDK
//
//  Created by 刘士林 on 2025/4/7.
//

#import "ALBannerViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface ALBannerViewController () <MAAdViewAdDelegate,MARewardedAdDelegate>
@property (nonatomic, strong) MAAdView *adView;
@property (nonatomic, strong) MARewardedAd *rewardedAd;
@property (nonatomic, assign) NSInteger retryAttempt;
@end

@implementation ALBannerViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"ALBannerViewController init");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ALBannerViewController viewDidLoad");
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 确保在主线程初始化SDK
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initializeAppLovinSDK];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"ALBannerViewController viewDidAppear");
}

- (void)initializeAppLovinSDK {
    NSLog(@"开始初始化AppLovin SDK");
    
    // 创建初始化配置
    ALSdkInitializationConfiguration *initConfig = [ALSdkInitializationConfiguration configurationWithSdkKey:@"iiPKo2OPZfcnWEuiF9oiqx5ybCgFA6Oaa6yntV85FrxUBUZEffuCLGbRtdsfFnKXluyH_HrtA4CB9AE0SR4s9O" builderBlock:^(ALSdkInitializationConfigurationBuilder *builder) {
        builder.mediationProvider = ALMediationProviderMAX;
    }];
    
    // 配置SDK设置
    ALSdkSettings *settings = [ALSdk shared].settings;
    settings.termsAndPrivacyPolicyFlowSettings.enabled = YES;
    settings.termsAndPrivacyPolicyFlowSettings.termsOfServiceURL = [NSURL URLWithString:@"https://www.applovin.com/terms/"];
    settings.termsAndPrivacyPolicyFlowSettings.privacyPolicyURL = [NSURL URLWithString:@"https://www.applovin.com/privacy/"];
//    [[ALSdk shared] showMediationDebugger];

    
    // 初始化SDK
    [[ALSdk shared] initializeWithConfiguration:initConfig completionHandler:^(ALSdkConfiguration *sdkConfig) {
        NSLog(@"AppLovin SDK初始化完成，配置信息：%@", sdkConfig);
        // 创建并加载banner广告
        [self setupAndLoadBannerAd];
    }];
}

- (void)setupAndLoadBannerAd {
    NSLog(@"开始创建和加载banner广告");
    
    // 创建banner广告视图
    self.adView = [[MAAdView alloc] initWithAdUnitIdentifier:@"43ae2507e7ea9f43" adFormat:MAAdFormat.banner];
    self.adView.delegate = self;
    
    // 设置广告视图大小
    self.adView.frame = CGRectMake(0, 0, 320, 50); // 标准banner尺寸
    
    // 设置广告视图位置
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.adView.center = CGPointMake(screenWidth / 2, 125); // 高度的一半
    self.adView.backgroundColor = UIColor.greenColor;
    
    // 添加到视图层级
//    [self.view addSubview:self.adView];
    
    NSLog(@"开始加载广告，广告单元ID: %@", self.adView.adUnitIdentifier);
    // 加载广告
//    [self.adView loadAd];
    self.rewardedAd = [MARewardedAd sharedWithAdUnitIdentifier: @"c379ee7e6590af22"];
    self.rewardedAd.delegate = self;
    
    // Load the first ad
    [self.rewardedAd loadAd];
}

#pragma mark - MAAdViewAdDelegate

- (void)didLoadAd:(MAAd *)ad
{
    NSLog(@"Banner ad loaded");
    if ( [self.rewardedAd isReady] )
    {
      [self.rewardedAd showAd];
    }
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error
{
    NSLog(@"Banner ad failed to load with error: %@", error);
}

- (void)didClickAd:(MAAd *)ad
{
    NSLog(@"Banner ad clicked");
}

- (void)didDisplayAd:(MAAd *)ad
{
    NSLog(@"Banner ad displayed");
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error
{
    NSLog(@"Banner ad failed to display with error: %@", error);
}

- (void)didExpandAd:(MAAd *)ad
{
    NSLog(@"Banner ad expanded");
}

- (void)didCollapseAd:(MAAd *)ad
{
    NSLog(@"Banner ad collapsed");
}

#pragma mark - MAAdDelegate Protocol


- (void)didHideAd:(MAAd *)ad
{
  // Rewarded ad is hidden. Pre-load the next ad
  [self.rewardedAd loadAd];
}

#pragma mark - MARewardedAdDelegate Protocol

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward
{
  // Rewarded ad was displayed and user should receive the reward
}
@end
