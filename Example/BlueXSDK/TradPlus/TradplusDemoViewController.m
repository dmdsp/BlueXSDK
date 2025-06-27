//
//  TradplusDemoViewController.m
//  DomobSDK
//
//  Created by 刘士林 on 2025/4/18.
//

#import "TradplusDemoViewController.h"
#import <TradPlusAds/TradPlus.h>
#import <TradPlusAds/TradPlusAdSplash.h>
#import <TradPlusAds/TradPlusAdBanner.h>

static NSString *cellWithIdentifier = @"cellWithIdentifier";


@interface TradplusDemoViewController ()<UITableViewDelegate,UITableViewDataSource,TradPlusADSplashDelegate,TradPlusADBannerDelegate>
@property (nonatomic, strong) TradPlusAdSplash *splashAd;
@property (nonatomic, strong) TradPlusAdBanner *banner;

@property (nonatomic, strong) UITableView *listTable;
@property (nonatomic, copy) NSArray *titleArr;
@end

@implementation TradplusDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArr= @[@"开屏",@"banner",@"激励视频"];
    self.view.backgroundColor = [UIColor whiteColor];
    [TradPlus initSDK:@"662F3FE8747378899FC03631E8764D9E" completionBlock:^(NSError *error){
        if (!error)
        {
            MSLogInfo(@"tradplus sdk init success!");
        }
    }];
    [self.view addSubview:self.listTable];
}
#pragma mark - 设置tableview
- (UITableView *)listTable{
    if (!_listTable) {
        _listTable = [[UITableView alloc]initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width-40,40*_titleArr.count) style:UITableViewStylePlain];
        _listTable.delegate = self;
        _listTable.dataSource = self;
        _listTable.backgroundColor = [UIColor whiteColor];
        _listTable.bounces = NO;
        if (@available(iOS 11.0, *)) {
            _listTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_listTable registerClass:[UITableViewCell class] forCellReuseIdentifier:cellWithIdentifier];
    }
    return _listTable;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        self.splashAd = [[TradPlusAdSplash alloc] init];
        self.splashAd.delegate = self;
        [self.splashAd setAdUnitID:@"05821C04D2E2326B33DE00E7F683E819"];
        [self.splashAd loadAdWithWindow:[UIApplication sharedApplication].keyWindow bottomView:nil];

    }else if (indexPath.row == 1){
        self.banner = [[TradPlusAdBanner alloc] init];
        [self.banner setAdUnitID:@"A335E2845290BF00975E1FA1F151572A"];
        self.banner.delegate = self;
        self.banner.frame = CGRectMake(0, 300, self.banner.bounds.size.width, self.banner.bounds.size.height);
        [self.view addSubview:self.banner];
        [self.banner loadAdWithSceneId:nil];
    }else if (indexPath.row == 2){
    }
   
}

//广告加载完成 首个广告源加载成功时回调 一次加载流程只会回调一次
- (void)tpSplashAdLoaded:(NSDictionary *)adInfo{
    if (self.splashAd.isAdReady)
    {
        [self.splashAd show];
    }
}

//广告加载失败
///tpSplashAdOneLayerLoad:didFailWithError：返回三方源的错误信息
- (void)tpSplashAdLoadFailWithError:(NSError *)error{
    
}

//广告展现成功 三方认可的有效展示
- (void)tpSplashAdImpression:(NSDictionary *)adInfo{
    
}

//广告展现失败
- (void)tpSplashAdShow:(NSDictionary *)adInfo didFailWithError:(NSError *)error{
    
}

//广告被点击
- (void)tpSplashAdClicked:(NSDictionary *)adInfo{
    
}

//广告关闭
- (void)tpSplashAdDismissed:(NSDictionary *)adInfo{
    
}

//广告加载完成 首个广告源加载成功时回调 一次加载流程只会回调一次
- (void)tpBannerAdLoaded:(NSDictionary *)adInfo{
    
}

//广告加载失败
///tpBannerAdOneLayerLoad:didFailWithError：返回三方源的错误信息
- (void)tpBannerAdLoadFailWithError:(NSError *)error{
    
}

//广告展现成功 三方认可的有效展示
- (void)tpBannerAdImpression:(NSDictionary *)adInfo{
    
}

//广告展现失败
- (void)tpBannerAdShow:(NSDictionary *)adInfo didFailWithError:(NSError *)error{
    
}

//广告被点击
- (void)tpBannerAdClicked:(NSDictionary *)adInfo{
    
}

///为三方提供rootviewController 用于点击广告后的操作
- (nullable UIViewController *)viewControllerForPresentingModalView{
    return self;
}

@end
