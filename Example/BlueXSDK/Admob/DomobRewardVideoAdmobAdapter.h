//
//  DomobRewardVideoAdmobAdapter.h
//  DomobSDK
//
//  Created by 刘士林 on 2025/6/10.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface DomobRewardVideoAdmobAdapter : NSObject 

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:
                           (GADMediationRewardedLoadCompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
