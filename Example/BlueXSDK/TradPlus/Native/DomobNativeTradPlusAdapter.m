//
//  DomobNativeTradPlusAdapter.m
//  DMAd
//
//  Created by 刘士林 on 2025/2/19.
//

#import "DomobNativeTradPlusAdapter.h"
#import <TradPlusAds/TradPlusAdWaterfallItem.h>
#import <TradPlusAds/MSConsentManager.h>
#import <DomobAdSDK/DMAds.h>
#import <DomobAdSDK/DM_NativeAd.h>


@interface DomobNativeTradPlusAdapter ()<DMNativeAdLoadDelegate>

@property (nonatomic, strong) DM_NativeAd * nativeAd;
@end

@implementation DomobNativeTradPlusAdapter
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
    return (self.nativeAd != nil);
}
//竞价成功后的加载流程
- (void)loadAdC2SBidding{
    if([self isReady]){
        //由于在获取ECPM时已经成功加载广告，此时则直接返回加载成功
        [self AdLoadFinsh];
    }else{
        //广告无效时返回加载失败
        NSError *loadError = [NSError errorWithDomain:@"domob.Native" code:404 userInfo:@{NSLocalizedDescriptionKey : @"C2S Native not ready"}];
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
    [self.nativeAd loadNativeAdTemplateAdWithSlotID:placementId delegate:self];
}
- (id)getCustomObject{
    return self.nativeAd;
}
//自渲染类型，在渲染完成后在此方法中进行三方注册操作
//模版类型，不要实现此方法
//- (UIView *)endRender:(NSDictionary *)viewInfo clickView:(NSArray *)array{
//    //按AdMob规则需要使用 GADNativeAdView 进行注册及展示
//    GADNativeAdView *nativeAdView = [[GADNativeAdView alloc] init];
//    nativeAdView.nativeAd = self.nativeAd;
//    //广告视图
//    if([viewInfo valueForKey:kTPRendererAdView])
//    {
//        UIView *view = viewInfo[kTPRendererAdView];
//        nativeAdView.frame = view.bounds;
//        [nativeAdView addSubview:view];
//    }
//    //广告标题
//    if([viewInfo valueForKey:kTPRendererTitleLable])
//    {
//        UIView *view = viewInfo[kTPRendererTitleLable];
//        nativeAdView.headlineView = view;
//    }
//    //广告描述
//    if([viewInfo valueForKey:kTPRendererTextLable])
//    {
//        UIView *view = viewInfo[kTPRendererTextLable];
//        nativeAdView.bodyView = view;
//    }
//    //广告按钮
//    if([viewInfo valueForKey:kTPRendererCtaLabel])
//    {
//        UIView *view = viewInfo[kTPRendererCtaLabel];
//        nativeAdView.callToActionView = view;
//    }
//    //广告图标
//    if([viewInfo valueForKey:kTPRendererIconView])
//    {
//        UIView *view = viewInfo[kTPRendererIconView];
//        nativeAdView.iconView = view;
//    }
//    //三方主视图
//    if(self.mediaView != nil)
//    {
//        nativeAdView.mediaView = self.mediaView;
//    }
//    //返回Admob的GADNativeAdView
//    return nativeAdView;
//}

#pragma --DMfeedAdDelegate
- (void)nativeAdDidFailToLoadWithError:(nonnull NSError *)error {
    NSString *errorStr = [NSString stringWithFormat:@"errCode: %@, errMsg: %@",  @"4001", @"C2S Bidding Fail"];
    [self failC2SBiddingWithErrorStr:errorStr];
    NSLog(@"feedAd加载失败");
}

- (void)nativeAdDidLoad:(nonnull DM_NativeAd *)nativeAd {
    NSLog(@"feedAd加载成功");
    TradPlusAdRes *res = [[TradPlusAdRes alloc] init];
    res.title = self.nativeAd.nativeModel.title;
    res.body = self.nativeAd.nativeModel.desc;
    self.waterfallItem.adRes = res;

    [self finishC2SBiddingWithEcpm:[NSString stringWithFormat:@"%ld",nativeAd.bidPrice]];
}
/// 广告已经打开
- (void)nativeAdDidShow:(DM_NativeAd *)nativeAd{
    NSLog(@"feedAd广告已经打开");
    [self AdShow];
}
//  广告被点击
- (void)nativeAdDidClick:(DM_NativeAd *)nativeAd{
    NSLog(@"feedAd广告已经点击");
    [self AdClick];
}

@end

