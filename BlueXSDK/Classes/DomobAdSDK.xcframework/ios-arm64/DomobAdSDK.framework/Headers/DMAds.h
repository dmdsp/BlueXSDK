//
//  DMAds.h
//  DomobAdSDK
//
//  Created by 刘士林 on 2024/3/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompletionEvent)(BOOL success);

@interface DMAds : NSObject

// 单例
+(instancetype)shareInstance;
/// 关闭定位权限,但还是需要配置,只是SDK不会去获取定位信息
-(void)setLocationDisable;
//SDK 初始化
-(void)initSDKWithAppId:(NSString*)appId;
//获取SDK版本号
-(NSString*)getSdkVersion;
//设备信息
-(NSString*)getSdkDevice;
//
///  设置调试模式,上线前请关闭.
/// - Parameter debugMode: 如果想获得测试广告请传Yes,默认为No,
- (void)setDebugMode:(BOOL)debugMode;
@end

NS_ASSUME_NONNULL_END
