//
//  DomobNativeRenderer.m
//  DMAd
//
//  Created by 刘士林 on 2024/8/27.
//

#import "DomobNativeRenderer.h"
#import "DomobNativeCustomEvent.h"

@interface DomobNativeRenderer ()
@property (nonatomic, strong) DomobNativeCustomEvent *customEvent;

@end
@implementation DomobNativeRenderer

-(void)renderOffer:(ATNativeADCache *)offer {
    [super renderOffer:offer];
    _customEvent = offer.assets[kATAdAssetsCustomEventKey];
    _customEvent.adView = self.ADView;
    self.ADView.customEvent = _customEvent;
    DM_NativeAd *feedAd = (DM_NativeAd *)offer.assets[kATAdAssetsCustomObjectKey];
    DM_NativeView * nativeView = [[DM_NativeView alloc]init];
    [nativeView addSubview:self.ADView];
    [feedAd registerContainer:nativeView];

}
@end
