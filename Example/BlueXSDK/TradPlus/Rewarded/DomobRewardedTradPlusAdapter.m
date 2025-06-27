//
//  DomobRewardedTradPlusAdapter.m
//  DMAd
//
//  Created by 刘士林 on 2025/2/19.
//

#import "DomobRewardedTradPlusAdapter.h"
#import <TradPlusAds/TradPlusAdWaterfallItem.h>
#import <TradPlusAds/MSConsentManager.h>
#import "DomobAdSDK/DMAds.h"
#import <DomobAdSDK/DM_RewardVideoAd.h>

@interface DomobRewardedTradPlusAdapter ()<DMRewardVideoAdDelegate>

@property (nonatomic, strong) DM_RewardVideoAd * rewardVideoAd;
@end

@implementation DomobRewardedTradPlusAdapter
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
    return (self.rewardVideoAd != nil);
}
//竞价成功后的加载流程
- (void)loadAdC2SBidding{
    if([self isReady]){
        //由于在获取ECPM时已经成功加载广告，此时则直接返回加载成功
        [self AdLoadFinsh];
    }else{
        //广告无效时返回加载失败
        NSError *loadError = [NSError errorWithDomain:@"domob.DM_RewardVideoAd" code:404 userInfo:@{NSLocalizedDescriptionKey : @"C2S DM_RewardVideoAd not ready"}];
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

    self.rewardVideoAd = [[DM_RewardVideoAd new] loadRewardVideoAdTemplateAdWithSlotID:placementId  delegate:self];

}
//展示广告
- (void)showAdFromRootViewController:(UIViewController *)rootViewController{
    NSError *error;
    if(rootViewController != nil){
        [self.rewardVideoAd biddingRewardVideoSuccess:self.rewardVideoAd.bidPrice];
        [self.rewardVideoAd showRewardVideoViewInRootViewController:rootViewController];
    }else{
        //展示失败
        [self AdShowFailWithError:error];
    }
}
#pragma --DMrewardVideoAdDelegate
- (void)rewardVideoAdDidFailToLoadWithError:(nonnull NSError *)error {
    NSString *errorStr = [NSString stringWithFormat:@"errCode: %@, errMsg: %@",  @"4001", @"C2S Bidding Fail"];
    [self failC2SBiddingWithErrorStr:errorStr];
    NSLog(@"rewardVideoAd加载失败");
}

- (void)rewardVideoAdDidLoad:(nonnull DM_RewardVideoAd *)rewardVideoAd {
    NSLog(@"rewardVideoAd加载成功");
}
/// 渲染成功
- (void)rewardVideoAdDidRender:(nonnull DM_RewardVideoAd *)rewardVideoAd {
    // 自定义底部视图
    [self finishC2SBiddingWithEcpm:[NSString stringWithFormat:@"%.2f",rewardVideoAd.bidPrice/100.0]];
}
/// 渲染失败
/// - Parameter error: 错误信息
- (void)rewardVideoAdDidFailToRenderWithError:(nonnull NSError *)error {
    NSString *errorStr = [NSString stringWithFormat:@"errCode: %@, errMsg: %@",  @"4001", @"C2S Bidding Fail"];
    [self failC2SBiddingWithErrorStr:errorStr];
    NSLog(@"rewardVideoAd渲染失败");
}
/// 广告已经打开
- (void)rewardVideoAdDidShow:(nonnull DM_RewardVideoAd *)rewardVideoAd {
    NSLog(@"rewardVideoAd广告已经打开");
    [self AdShow];
}
//  广告被点击
- (void)rewardVideoAdDidClick:(nonnull DM_RewardVideoAd *)rewardVideoAd {
    NSLog(@"rewardVideoAd广告已经点击");
    [self AdClick];
}
- (void)rewardVideoAdDidComplete:(DM_RewardVideoAd *)rewardVideoAd{
    NSLog(@"rewardVideoAd发奖");
    [self AdRewardedWithInfo:[NSDictionary new]];
}
///播放失败的回调
- (void)rewardVideoAdDidFailToShowWithError:(NSError *)error{
    NSLog(@"rewardVideoAd播放失败");
    [self AdShowFailWithError:error];
}
///视频播放完成
- (void)rewardVideoAdPlayToEndTime:(DM_RewardVideoAd *)rewardVideoAd{
    NSLog(@"rewardVideoAd播放完成");
}

- (void)rewardVideoAdDidClose:(nonnull DM_RewardVideoAd *)rewardVideoAd { 
    
}



@end
