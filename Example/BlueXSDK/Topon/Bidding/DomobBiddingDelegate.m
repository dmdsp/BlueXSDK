//
//  DomobBiddingDelegate.m
//  DMAd
//
//  Created by 刘士林 on 2024/9/6.
//

#import "DomobBiddingDelegate.h"
#import "DomobBiddingRequest.h"
#import "DomobBiddingManager.h"
#import <AnyThinkSplash/AnyThinkSplash.h>
#import <AnyThinkNative/AnyThinkNative.h>

@interface DomobBiddingDelegate ()
@end
@implementation DomobBiddingDelegate

#pragma - splash
- (void)splashAdDidLoad:(nonnull DM_SplashAd *)splashAd {
    DomobBiddingRequest *request = [[DomobBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    NSLog(@"request.unitGroup.bidTokenTime = %f",request.unitGroup.bidTokenTime);
    ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:request.placementID unitGroupUnitID:request.unitGroup.unitID adapterClassString:request.unitGroup.adapterClassString price:[NSString stringWithFormat:@"%ld",splashAd.bidPrice] currencyType:ATBiddingCurrencyTypeCNYCents expirationInterval:request.unitGroup.bidTokenTime customObject:splashAd];
    bidInfo.networkFirmID = request.unitGroup.networkFirmID;
    if(request.bidCompletion){
        request.bidCompletion(bidInfo, nil);
    }
}
- (void)splashAdDidFailToLoadWithError:(NSError *)error{
    
}



#pragma - banner
- (void)bannerAdDidLoad :(DM_BannerAd*)bannerAd{
    DomobBiddingRequest *request = [[DomobBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    NSLog(@"request.unitGroup.bidTokenTime = %f",request.unitGroup.bidTokenTime);
    ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:request.placementID unitGroupUnitID:request.unitGroup.unitID adapterClassString:request.unitGroup.adapterClassString price:[NSString stringWithFormat:@"%ld",bannerAd.bidPrice] currencyType:ATBiddingCurrencyTypeCNYCents expirationInterval:request.unitGroup.bidTokenTime customObject:bannerAd];
    bidInfo.networkFirmID = request.unitGroup.networkFirmID;
    if(request.bidCompletion){
        request.bidCompletion(bidInfo, nil);
    }
}
- (void)bannerAdDidFailToLoadWithError:(NSError *)error{
    
}

#pragma - rewardVideo
- (void)rewardVideoAdDidLoad:(nonnull DM_RewardVideoAd *)rewardVideoAd {
    DomobBiddingRequest *request = [[DomobBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    NSLog(@"request.unitGroup.bidTokenTime = %f",request.unitGroup.bidTokenTime);
    ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:request.placementID unitGroupUnitID:request.unitGroup.unitID adapterClassString:request.unitGroup.adapterClassString price:[NSString stringWithFormat:@"%ld",rewardVideoAd.bidPrice] currencyType:ATBiddingCurrencyTypeCNYCents expirationInterval:request.unitGroup.bidTokenTime customObject:rewardVideoAd];
    bidInfo.networkFirmID = request.unitGroup.networkFirmID;
    if(request.bidCompletion){
        request.bidCompletion(bidInfo, nil);
    }
}
- (void)rewardVideoAdDidFailToLoadWithError:(NSError *)error{
    
}
#pragma - feedAd
- (void)nativeAdDidLoad:(nonnull DM_NativeAd *)nativeAd {
    DomobBiddingRequest *request = [[DomobBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    NSLog(@"request.unitGroup.bidTokenTime = %f",request.unitGroup.bidTokenTime);
    ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:request.placementID unitGroupUnitID:request.unitGroup.unitID adapterClassString:request.unitGroup.adapterClassString price:[NSString stringWithFormat:@"%ld",nativeAd.bidPrice] currencyType:ATBiddingCurrencyTypeCNYCents expirationInterval:request.unitGroup.bidTokenTime customObject:nativeAd];
    bidInfo.networkFirmID = request.unitGroup.networkFirmID;
    if(request.bidCompletion){
        request.bidCompletion(bidInfo, nil);
    }
}
- (void)nativeAdDidFailToLoadWithError:(nonnull NSError *)error {

}
@end
