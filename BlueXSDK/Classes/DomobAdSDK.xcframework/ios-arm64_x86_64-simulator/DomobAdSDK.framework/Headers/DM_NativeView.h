//
//  DM_NativeView.h
//  DomobAdSDK
//
//  Created by 刘士林 on 2025/3/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickLinkEvent)(void);
typedef void(^ClickCloseEvent)(void);
typedef void(^DidShowEvent)(void);

@interface DM_NativeView : UIView
@property (nonatomic, copy) DidShowEvent showEvent;

@end

NS_ASSUME_NONNULL_END
