//
//  BannerAdViewController.m
//  DMAd
//
//  Created by 刘士林 on 2024/3/27.
//
#import "BannerAdViewController.h"
#import "UIView+Toast.h"

#import <DomobAdSDK/DMAds.h>
#import <DomobAdSDK/DM_BannerAd.h>
#import <DomobAdSDK/DM_BannerView.h>
static NSString *cellWithIdentifier = @"cellWithIdentifier";

@interface BannerAdViewController ()<UITableViewDelegate,UITableViewDataSource,DMBannerAdDelegate>
@property (nonatomic, strong) UITableView *listTable;

@property (nonatomic, copy) NSArray *titleArr;

@property (nonatomic, strong) DM_BannerAd * bannerAd;


@end

@implementation BannerAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];;
    self.titleArr= @[@"ViewSize320x50"];
    [self.view addSubview:self.listTable];
    
}
#pragma mark - 设置tableview
- (UITableView *)listTable{
    if (!_listTable) {
        _listTable = [[UITableView alloc]initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width-40,40*_titleArr.count) style:UITableViewStylePlain];
        _listTable.delegate = self;
        _listTable.dataSource = self;
        _listTable.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];;
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
    cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
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
    [self.bannerAd.bannerView removeFromSuperview];
        self.bannerAd = [[DM_BannerAd new] loadBannerAdTemplateAdWithSlotID:@"124191739261611363448179"  delegate:self];
  
}
#pragma  ---DMBannerAdDelegate

- (void)bannerAdDidFailToLoadWithError:(nonnull NSError *)error {
    [self.view makeToast:[NSString stringWithFormat:@"bannerAd加载失败"]
                duration:3.0
                position:CSToastPositionCenter];
}

- (void)bannerAdDidLoad:(nonnull DM_BannerAd *)bannerAd {
    [self.view makeToast:[NSString stringWithFormat:@"bannerAd加载成功"]
                duration:3.0
                position:CSToastPositionCenter];
    
//    [bannerAd biddingBannerSuccess:10001];
    [bannerAd biddingBannerFailed:1800 Code:104];
    //可以将view展示在当前的视图上
    self.bannerAd = bannerAd;
//    self.bannerAd.bannerView.backgroundColor = [UIColor greenColor];
    self.bannerAd.bannerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, self.bannerAd.bannerView.bounds.size.width, self.bannerAd.bannerView.bounds.size.height);
    [self.view addSubview:self.bannerAd.bannerView];
}
- (void)bannerAdDidShow:(nonnull DM_BannerAd *)bannerAd {
    [self.listTable reloadData];
    [self.view makeToast:[NSString stringWithFormat:@"bannerAd已经开始展示"]
                duration:3.0
                position:CSToastPositionCenter];
}
/// 广告被关闭
- (void)bannerAdDidClose:(DM_BannerAd *)bannerAd{
    [self.view makeToast:[NSString stringWithFormat:@"bannerAd被关闭了"]
                duration:3.0
                position:CSToastPositionCenter];
}
- (void)bannerAdDidClick:(DM_BannerAd *)bannerAd{
    [self.view makeToast:[NSString stringWithFormat:@"bannerAd被点击了"]
                duration:3.0
                position:CSToastPositionCenter];
}

@end
