//
//  DM_InterstitialAd.h
//  DomobAdSDK
//
//  Created by 刘士林 on 2025/6/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

NS_ASSUME_NONNULL_BEGIN
@protocol DMInterstitialAdDelegate;

@interface DM_InterstitialAd : NSObject
//广告位id
@property (nonatomic, copy, readonly, nonnull) NSString *slotID;
//当前广告的报价
@property(nonatomic, assign, readonly) long bidPrice;
//竞价成功地址
@property (nonatomic , copy ,readonly)NSArray  * winNoticeUrl ;
//竞价失败地址
@property (nonatomic , copy, readonly) NSArray * lnurl;

@property (nonatomic , copy) NSString * rid ;

/// 初始化插屏、代理
/// - Parameter delegate: 代理
/// - Parameter slotID: 广告位id
- (instancetype)loadInterstitialAdTemplateAdWithSlotID:(NSString *)slotID delegate:(id<DMInterstitialAdDelegate>)delegate ;
//竞价成功的上报
- (void)biddingInterstitialAdSuccess:(long)price;
//竞价失败的上报
- (void)biddingInterstitialAdFailed:(long)price Code:(int)code;
/// 展示广告
/// - Parameter viewController: 传入一个控制器
-(void)showInterstitialViewInRootViewController:(UIViewController *)viewController;
- (BOOL)isReady;
@end

@protocol DMInterstitialAdDelegate <NSObject>
/// 加载成功
- (void)interstitialAdDidLoad :(DM_InterstitialAd*)interstitialAd;
/// 加载失败
- (void)interstitialAdDidFailToLoadWithError:(NSError *)error;
/// 渲染成功
- (void)interstitialAdDidRender:(DM_InterstitialAd*)interstitialAd;;
/// 渲染失败
- (void)interstitialAdDidFailToRenderWithError:(NSError *)error;
/// 广告已经打开
- (void)interstitialAdDidShow:(DM_InterstitialAd *)interstitialAd;
/// 广告被点击
- (void)interstitialAdDidClick:(DM_InterstitialAd *)interstitialAd;
/// 广告被关闭
- (void)interstitialAdDidClose:(DM_InterstitialAd *)interstitialAd;
///播放失败的回调
- (void)interstitialAdDidFailToShowWithError:(NSError *)error;
///视频播放完成
- (void)interstitialAdPlayToEndTime:(DM_InterstitialAd *)interstitialAd;
@end

NS_ASSUME_NONNULL_END
