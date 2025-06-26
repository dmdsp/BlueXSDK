//
//  DM_NativeModel.h
//  DomobAdSDK
//
//  Created by 刘士林 on 2025/3/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DM_NativeModel : NSObject
/**
logo链接
 */
@property (nonatomic,copy) NSString *iconUrl;
/**
 logo大小
 */
@property (nonatomic,assign) CGSize iconSize;
/**
 标题
 */
@property (nonatomic,copy) NSString *title;
/**
 描述
 */
@property (nonatomic,copy) NSString *desc;
/**
 按钮文字
 */
@property (nonatomic,copy) NSString *btnText;
/**
图片链接
 */
@property (nonatomic,copy) NSString *imgUrl;
/**
 图片大小
 */
@property (nonatomic,assign) CGSize imgSize;
/**
 赞助商名称
 */
@property (nonatomic,copy) NSString *sponsored;

@end

NS_ASSUME_NONNULL_END
