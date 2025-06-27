//
//  DM_BannerView.h
//  DomobAdSDK
//
//  Created by 刘士林 on 2024/3/28.
//

#import <UIKit/UIKit.h>
#import <DomobAdSDK/DM_BannerAd.h>

NS_ASSUME_NONNULL_BEGIN
@class DM_ADModel;

typedef void(^ClickCloseEvent)(void);
typedef void(^DidShowEvent)(void);
typedef void(^ClickLinkEvent)(void);

@interface DM_BannerView : UIView

@property (nonatomic, copy) ClickCloseEvent closeEvent;
@property (nonatomic, copy) DidShowEvent showEvent;
@property (nonatomic, copy) ClickLinkEvent linkEvent;
@property (nonatomic, strong) DM_ADModel *adModel;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

-(instancetype)initWithBannerViewSize:(CGSize)viewSize content:(NSString*)content isVASTProtocol:(BOOL)isVASTProtocol;
//关闭当前view
- (void)dismissADView;
@end

NS_ASSUME_NONNULL_END
 
