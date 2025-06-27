//
//  DomobNativeCustomEvent.h
//  DMAd
//
//  Created by 刘士林 on 2024/8/27.
//

#import <AnyThinkNative/AnyThinkNative.h>
#import <DomobAdSDK/DM_NativeAd.h>

NS_ASSUME_NONNULL_BEGIN

@interface DomobNativeCustomEvent : ATNativeADCustomEvent <DMNativeAdLoadDelegate>
- (void)feedRendering:(DM_NativeAd *)nativeAd ;
@end

NS_ASSUME_NONNULL_END
