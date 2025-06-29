//
//  DM_SplashAd.h
//  DMAdSDK
//
//  Created by 刘士林 on 2024/3/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol DMSplashAdDelegate;
@interface DM_SplashAd : NSObject
//广告位id
@property (nonatomic, copy, readonly, nonnull) NSString *slotID;
//当前广告的报价
@property(nonatomic, assign, readonly) long bidPrice;
//竞价成功地址
@property (nonatomic , copy ,readonly)NSArray  * winNoticeUrl ;
//竞价失败地址
@property (nonatomic , copy, readonly) NSArray * lnurl ;
//开屏的view,如果有特殊需要可以直接展示
@property (nonatomic, strong, readonly) UIView *dmSplashView;
//使用controller present 落地页
@property (nonatomic, weak) UIViewController *presentAdViewController;

@property (nonatomic , copy) NSString * materialId ;
@property (nonatomic , copy) NSString * rid ;
/// 初始化开屏广告和配置代理
/// - Parameter delegate: 代理
/// - Parameter slotID: 广告位id
- (instancetype)loadSplashAdTemplateAdWithSlotID:(NSString *)slotID delegate:(id<DMSplashAdDelegate>)delegate ;
//竞价成功的上报
- (void)biddingSplashSuccess:(long)price;
//竞价失败的上报
- (void)biddingSplashFailed:(long)price Code:(int)code;
/// 展示广告
/// - Parameter viewController: 当前要展示的控制器
-(void)showSplashViewInRootViewController:(UIViewController *)viewController;

@end

@protocol DMSplashAdDelegate <NSObject>
/// 加载成功
- (void)splashAdDidLoad :(DM_SplashAd*)splashAd;
/// 加载失败
- (void)splashAdDidFailToLoadWithError:(NSError *)error;
/// 广告已经打开
- (void)splashAdDidShow:(DM_SplashAd *)splashAd;
/// 广告被点击
- (void)splashAdDidClick:(DM_SplashAd *)splashAd;
/// 广告被关闭
- (void)splashAdDidClose:(DM_SplashAd *)splashAd;
@end
NS_ASSUME_NONNULL_END
