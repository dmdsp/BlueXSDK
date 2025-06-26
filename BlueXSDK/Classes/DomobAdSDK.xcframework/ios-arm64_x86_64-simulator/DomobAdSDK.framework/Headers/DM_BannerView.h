//
//  DM_BannerView.h
//  DomobAdSDK
//
//  Created by 刘士林 on 2024/3/28.
//

#import <UIKit/UIKit.h>
#import <DomobAdSDK/DM_BannerAd.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickCloseEvent)(void);
typedef void(^DidShowEvent)(void);
typedef void(^ClickLinkEvent)(void);

@interface DM_BannerView : UIView

@property (nonatomic, copy) ClickCloseEvent closeEvent;
@property (nonatomic, copy) DidShowEvent showEvent;
@property (nonatomic, copy) ClickLinkEvent linkEvent;

-(instancetype)initWithBannerViewSize:(CGSize)viewSize content:(NSString*)content;
//关闭当前view
- (void)dismissADView;
@end

NS_ASSUME_NONNULL_END
