//
//  DomobBannerTradPlusAdapter.m
//  DMAd
//
//  Created by 刘士林 on 2025/2/19.
//

#import "DomobBannerTradPlusAdapter.h"
#import <TradPlusAds/TradPlusAdWaterfallItem.h>
#import <TradPlusAds/MSConsentManager.h>
#import <DomobAdSDK/DMAds.h>
#import <DomobAdSDK/DM_BannerAd.h>
#import <DomobAdSDK/DM_BannerView.h>

@interface DomobBannerTradPlusAdapter ()<DMBannerAdDelegate>

@property (nonatomic, strong) DM_BannerAd * bannerAd;
@end

@implementation DomobBannerTradPlusAdapter
//根据event实现相关流程
- (BOOL)extraActWithEvent:(NSString *)event info:(NSDictionary *)config{
    //    event="C2SBidding"，SDK开始竞价流程，自定义Adapter需要从三方SDK相关接口获取ECPM。
    //    event="LoadAdC2SBidding"，竞价已经结束进行加载流程中，自定义Adapter需要根据三方SDK进行加载流程。
    if([event isEqualToString:@"C2SBidding"]){
        //从三方SDK获取价格
        [[DMAds shareInstance] initSDKWithAppId:@"1234"];
        [self getECPMC2SBidding];
    }else if([event isEqualToString:@"LoadAdC2SBidding"]){
        //竞价成功后的加载
        [self loadAdC2SBidding];
    }else{
        return NO;
    }
    return YES;
}
- (void)getECPMC2SBidding{
    [self loadAdWithWaterfallItem:self.waterfallItem];
}
//此方法用于返回是否过期状态
- (BOOL)isReady{
    return (self.bannerAd != nil);
}
//竞价成功后的加载流程
- (void)loadAdC2SBidding{
    if([self isReady]){
        //由于在获取ECPM时已经成功加载广告，此时则直接返回加载成功
        [self AdLoadFinsh];
        [self.bannerAd biddingBannerSuccess:self.bannerAd.bidPrice];
    }else{
        //广告无效时返回加载失败
        NSError *loadError = [NSError errorWithDomain:@"domob.banner" code:404 userInfo:@{NSLocalizedDescriptionKey : @"C2S banner not ready"}];
        [self AdLoadFailWithError:loadError];
    }
}
//获取ECPM成功
- (void)finishC2SBiddingWithEcpm:(NSString *)ecpmStr{
    //三方版本号
    NSString *version = [[DMAds shareInstance] getSdkVersion];
    if(version == nil){
        version = @"";
    }
    if(ecpmStr == nil){
        ecpmStr = @"0";
    }
    //通过接口向TradPlusSDK回传ecpm和三方版本号
    NSDictionary *dic = @{@"ecpm":ecpmStr,@"version":version};
    [self ADLoadExtraCallbackWithEvent:@"C2SBiddingFinish" info:dic];
}

//获取ECPM失败
- (void)failC2SBiddingWithErrorStr:(NSString *)errorStr{
    NSDictionary *dic = @{@"error":errorStr};
    [self ADLoadExtraCallbackWithEvent:@"C2SBiddingFail" info:dic];
}
//初始化自定义平台，设置平台参数（海外平台的隐私设置）加载广告
- (void)loadAdWithWaterfallItem:(TradPlusAdWaterfallItem *)item
{
    //通过 item.config 获取后台配置信息
    NSString *placementId = item.config[@"placementId"];
    if(placementId == nil){
        //配置错误
        [self AdConfigError];
        return;
    }
    self.bannerAd = [[DM_BannerAd new] loadBannerAdTemplateAdWithSlotID:placementId delegate:self];

}
- (id)getCustomObject{
    return self.bannerAd.bannerView;
}
#pragma --DMbannerAdDelegate
- (void)bannerAdDidFailToLoadWithError:(nonnull NSError *)error {
    NSString *errorStr = [NSString stringWithFormat:@"errCode: %@, errMsg: %@",  @"4001", @"C2S Bidding Fail"];
    [self failC2SBiddingWithErrorStr:errorStr];
    NSLog(@"bannerAd加载失败");
}

- (void)bannerAdDidLoad:(nonnull DM_BannerAd *)bannerAd {
    NSLog(@"bannerAd加载成功");
    [self finishC2SBiddingWithEcpm:[NSString stringWithFormat:@"%.2f",bannerAd.bidPrice/100.0]];

}
/// 广告已经打开
- (void)bannerAdDidShow:(nonnull DM_BannerAd *)bannerAd {
    NSLog(@"bannerAd广告已经打开");
    [self AdShow];
}
//  广告被点击
- (void)bannerAdDidClick:(nonnull DM_BannerAd *)bannerAd {
    NSLog(@"bannerAd广告已经点击");
    [self AdClick];
}
//  广告被关闭
- (void)bannerAdDidClose:(DM_BannerAd *)bannerAd{
    [self AdClose];
    NSLog(@"bannerAd广告已经关闭");
}
@end
