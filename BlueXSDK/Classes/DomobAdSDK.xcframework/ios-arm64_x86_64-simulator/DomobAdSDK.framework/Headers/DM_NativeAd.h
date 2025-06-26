//
//  DM_NativeAd.h
//  DomobAdSDK
//
//  Created by 刘士林 on 2025/2/25.
//

#import <Foundation/Foundation.h>
#import "DM_NativeView.h"
#import "DM_NativeModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DMNativeAdLoadDelegate;

@interface DM_NativeAd : NSObject
//广告位id
@property (nonatomic, copy, readonly, nonnull) NSString *slotID;
//当前广告的报价
@property(nonatomic, assign, readonly) long bidPrice;
//竞价成功地址
@property (nonatomic , copy ,readonly)NSArray  * winNoticeUrl ;
//竞价失败地址
@property (nonatomic , copy, readonly) NSArray * lnurl;
//使用controller present 落地页
@property (nonatomic, weak) UIViewController *presentAdViewController;
//返回自渲染的数据
@property (nonatomic,strong)DM_NativeModel * nativeModel;

/// - Parameter delegate: 代理
/// - Parameter slotID: 广告位id
- (instancetype)loadNativeAdTemplateAdWithSlotID:(NSString *)slotID delegate:(id<DMNativeAdLoadDelegate>)delegate;

//竞价成功的上报
- (void)biddingNativSuccess:(long)price;
//竞价失败的上报
- (void)biddingNativeFailed:(long)price Code:(int)code;
//自渲染传入的view
- (void)registerContainer:(DM_NativeView*)container;
//注册点击事件,如果未调用或者数组为空将默认整个view可以点击
- (void)registerClickableViews:(NSArray<__kindof UIView *> *_Nullable)clickableViews;
//移除点击
- (void)removeClickableViews;
//关闭当前view
- (void)dismissADView;

@end
@protocol DMNativeAdLoadDelegate <NSObject>
/// 加载成功
- (void)nativeAdDidLoad :(DM_NativeAd*)nativeAd;
/// 加载失败
- (void)nativeAdDidFailToLoadWithError:(NSError *)error;
/// 广告已经打开
- (void)nativeAdDidShow:(DM_NativeAd *)nativeAd;
/// 广告被点击
- (void)nativeAdDidClick:(DM_NativeAd *)nativeAd;
@end

NS_ASSUME_NONNULL_END
