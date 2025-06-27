//
//  DomobNativeCustomEvent.m
//  DMAd
//
//  Created by 刘士林 on 2024/8/27.
//

#import "DomobNativeCustomEvent.h"


@interface DomobNativeCustomEvent ()

@end

@implementation DomobNativeCustomEvent
- (void)nativeAdDidClick:(DM_NativeAd *)nativeAd{
    [self trackNativeAdClick];
}

- (void)nativeAdDidFailToLoadWithError:(NSError *)error{
    [self trackNativeAdLoadFailed:error];
}

- (void)nativeAdDidLoad:(nonnull DM_NativeAd *)nativeAd {

}

- (void)nativeAdDidShow:(DM_NativeAd *)nativeAd{
    [self trackNativeAdShow:YES];
}

- (void)feedRendering:(DM_NativeAd *)nativeAd {
    NSMutableDictionary *asset = [NSMutableDictionary dictionary];
    [asset setValue:self forKey:kATAdAssetsCustomEventKey];
    [asset setValue:self forKey:kATAdAssetsDelegateObjKey];
    [asset setValue:self forKey:kATAdAssetsNativeCustomEventKey];
    [asset setValue:nativeAd forKey:kATAdAssetsCustomObjectKey];
  
    
    [asset setValue:nativeAd.nativeModel.title forKey:kATNativeADAssetsMainTitleKey];
    [asset setValue:nativeAd.nativeModel.desc forKey:kATNativeADAssetsMainTextKey];

    [asset setValue:nativeAd.nativeModel.iconUrl forKey:kATNativeADAssetsIconURLKey];
    [asset setValue:nativeAd.nativeModel.imgUrl forKey:kATNativeADAssetsImageURLKey];

    [asset setValue:@(NO) forKey:kATNativeADAssetsContainsVideoFlag];

    NSMutableArray<NSDictionary*>* assets = [NSMutableArray<NSDictionary*> array];
    [assets addObject:asset];
    [self trackNativeAdLoaded:assets];
}

@end
