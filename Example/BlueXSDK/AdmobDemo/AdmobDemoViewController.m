//
//  AdmobDemoViewController.m
//  DomobSDK
//
//  Created by 刘士林 on 2025/6/12.
//

#import "AdmobDemoViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AdmobDemoViewController () <GADBannerViewDelegate, GADFullScreenContentDelegate>
@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) GADRewardedAd *rewardedAd;
@end

@implementation AdmobDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ @"b13ac92a889271e9cb5385aa1cf6e74d" ];

//    [self loadBannerAd];
    [self loadRewardedAd];
}

#pragma mark - 加载 Banner

- (void)loadBannerAd {
    // 替换为你在 AdMob 后台配置的 Banner 广告单元ID
    NSString *bannerAdUnitID = @"ca-app-pub-1268667673005696/9136709675";
    self.bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeBanner];
    self.bannerView.adUnitID = bannerAdUnitID;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    self.bannerView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 50);
    [self.view addSubview:self.bannerView];

    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
}

#pragma mark - GADBannerViewDelegate

- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"Banner 加载成功");
}

- (void)bannerView:(GADBannerView *)bannerView
    didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Banner 加载失败: %@", error.localizedDescription);
}

#pragma mark - 加载激励视频

- (void)loadRewardedAd {
    // 替换为你在 AdMob 后台配置的激励视频广告单元ID
    NSString *rewardedAdUnitID = @"ca-app-pub-1268667673005696/2192861524";
    GADRequest *request = [GADRequest request];
    [GADRewardedAd loadWithAdUnitID:rewardedAdUnitID
                            request:request
                  completionHandler:^(GADRewardedAd *ad, NSError *error) {
        if (error) {
            NSLog(@"激励视频加载失败: %@", error.localizedDescription);
            return;
        }
        self.rewardedAd = ad;
        self.rewardedAd.fullScreenContentDelegate = self;
        NSLog(@"激励视频加载成功");
    }];
}

- (void)showRewardedAd {
    if (self.rewardedAd) {
        [self.rewardedAd presentFromRootViewController:self
                              userDidEarnRewardHandler:^{
            NSLog(@"用户获得奖励");
        }];
    } else {
        NSLog(@"激励视频未加载好");
    }
}

#pragma mark - GADFullScreenContentDelegate

- (void)adDidDismissFullScreenContent:(id)ad {
    NSLog(@"激励视频关闭，重新加载");
    [self loadRewardedAd];
}

@end

