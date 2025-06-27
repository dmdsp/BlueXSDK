//
//  SplashAViewController.m
//  DomobSDK
//
//  Created by 刘士林 on 2025/4/7.
//

#import "SplashAViewController.h"

#import "BannerAdViewController.h"
#import "RewardVideoAdViewController.h"
#import "InterstitialAdViewController.h"

#import <DomobAdSDK/DMAds.h>
#import "NativeAdViewController.h"
#import <DomobAdSDK/DM_SplashAd.h>
#import "UIView+Toast.h"

static NSString *cellWithIdentifier = @"cellWithIdentifier";

@interface SplashAViewController ()<UITableViewDelegate,UITableViewDataSource,DMSplashAdDelegate>
@property (nonatomic, strong) UITableView *listTable;
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, strong) DM_SplashAd * splashAd;

@end

@implementation SplashAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleArr= @[[[DMAds shareInstance] getSdkVersion],@"模版渲染Banner广告",@"模版渲染激励视频广告",@"自渲染原生广告",@"开屏广告",@"插屏广告"];
    [[DMAds shareInstance] initSDKWithAppId:@"1234"];
//    [[DMAds shareInstance] setDebugMode:YES];
    [self.view addSubview:self.listTable];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
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
    if (indexPath.row==0) {
    }else if (indexPath.row==1) {
        BannerAdViewController * banner = [[BannerAdViewController alloc]init];
        [self.navigationController pushViewController:banner animated:YES];
    }else if (indexPath.row==2) {
        RewardVideoAdViewController * rewardVideo = [[RewardVideoAdViewController alloc]init];
        [self.navigationController pushViewController:rewardVideo animated:YES];
    }else if (indexPath.row==3) {
        NativeAdViewController * native = [[NativeAdViewController alloc]init];
        [self.navigationController pushViewController:native animated:YES];
    }else if (indexPath.row==4) {
        self.splashAd  = [DM_SplashAd new];
        [self.splashAd loadSplashAdTemplateAdWithSlotID:@"124231742807508532485984"  delegate:self]; 
    }else if (indexPath.row==5) {
        InterstitialAdViewController * interstitial = [[InterstitialAdViewController alloc]init];
        [self.navigationController pushViewController:interstitial animated:YES];
    }
}
#pragma --DMSplashAdDelegate
- (void)splashAdDidFailToLoadWithError:(nonnull NSError *)error {
    NSLog(@"splashAd加载失败");
    [self.view makeToast:@"splashAd加载失败"
                                     duration:3.0
                position:CSToastPositionCenter];
}

- (void)splashAdDidLoad :(DM_SplashAd*)splashAd;{
    NSLog(@"splashAd加载成功");
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view makeToast:@"splashAd加载成功"
                                     duration:3.0
                position:CSToastPositionCenter];
    [_splashAd biddingSplashSuccess:100];
    [_splashAd biddingSplashFailed:101 Code:132];
    //然后展示
    [self.view addSubview:splashAd.dmSplashView];
//    [self.splashAd showSplashViewInRootViewController:self];

}
/// 广告已经打开
- (void)splashAdDidShow:(DM_SplashAd *)splashAd{
    NSLog(@"splashAd广告已经打开");
    [self.view makeToast:[NSString stringWithFormat:@"plashAd广告已经打开--%@",_splashAd.materialId]
                                     duration:3.0
                position:CSToastPositionCenter];
}
//  广告被点击
- (void)splashAdDidClick:(DM_SplashAd *)splashAd{
    NSLog(@"splashAd广告已经点击");
    [self.view makeToast:[NSString stringWithFormat:@"splashAd广告已经点击--%@",_splashAd.materialId]
                                     duration:3.0
                position:CSToastPositionCenter];
//    [splashAd.dmSplashView removeFromSuperview];
}
//  广告被关闭
- (void)splashAdDidClose:(DM_SplashAd *)splashAd{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.view makeToast:[NSString stringWithFormat:@"splashAd广告已经关闭--%@",_splashAd.materialId]
                                     duration:3.0
                position:CSToastPositionCenter];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}
@end
