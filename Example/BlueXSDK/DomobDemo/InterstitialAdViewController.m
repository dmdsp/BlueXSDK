//
//  InterstitialAdViewController.m
//  DomobSDK
//
//  Created by 刘士林 on 2025/6/4.
//

#import "InterstitialAdViewController.h"

#import "UIView+Toast.h"

#import "DomobAdSDK/DMAds.h"
#import <DomobAdSDK/DM_InterstitialAd.h>

static NSString *cellWithIdentifier = @"cellWithIdentifier";

@interface InterstitialAdViewController ()<UITableViewDelegate,UITableViewDataSource,DMInterstitialAdDelegate>
@property (nonatomic, strong) UITableView *listTable;
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, strong) DM_InterstitialAd * interstitialAd;
@end

@implementation InterstitialAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];;
    self.titleArr= @[@"插屏",];
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
    self.interstitialAd  = [DM_InterstitialAd new];
    [self.interstitialAd loadInterstitialAdTemplateAdWithSlotID:@"124191748402050798197108"  delegate:self];
}
#pragma  ---DMInterstitialAdDelegate
- (void)interstitialAdDidClick:(nonnull DM_InterstitialAd *)interstitialAd {
    [self.listTable reloadData];
    [self.view makeToast:[NSString stringWithFormat:@"interstitialAd被点击--%@",_interstitialAd.slotID]
                duration:3.0
                position:CSToastPositionCenter];
}
- (void)interstitialAdDidFailToLoadWithError:(nonnull NSError *)error {
    [self.view makeToast:[NSString stringWithFormat:@"interstitialAd加载失败--%@",_interstitialAd.slotID]
                duration:3.0
                position:CSToastPositionCenter];

}

- (void)interstitialAdDidFailToRenderWithError:(nonnull NSError *)error {
    [self.view makeToast:[NSString stringWithFormat:@"interstitialAd渲染失败--%@",_interstitialAd.slotID]
                duration:3.0
                position:CSToastPositionCenter];
}

- (void)interstitialAdDidLoad:(nonnull DM_InterstitialAd *)interstitialAd {
    [self.view makeToast:[NSString stringWithFormat:@"interstitialAd加载成功--%@",_interstitialAd.slotID]
                duration:3.0
                position:CSToastPositionCenter];
    [interstitialAd biddingInterstitialAdFailed:1800 Code:104];
    [interstitialAd biddingInterstitialAdSuccess:10001];
}

- (void)interstitialAdDidRender:(nonnull DM_InterstitialAd *)interstitialAd {
    [self.view makeToast:[NSString stringWithFormat:@"interstitialAd渲染成功--%@",_interstitialAd.slotID]
                duration:3.0
                position:CSToastPositionCenter];
    //渲染成功后已经将view返回
    //可以将view展示在当前的视图上
    self.interstitialAd = interstitialAd;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.interstitialAd showInterstitialViewInRootViewController:self];
}

- (void)interstitialAdDidShow:(nonnull DM_InterstitialAd *)interstitialAd {
    [self.listTable reloadData];
    [self.view makeToast:[NSString stringWithFormat:@"interstitialAd已经开始展示--%@",_interstitialAd.slotID]
                duration:3.0
                position:CSToastPositionCenter];
}
/// 广告被关闭
- (void)interstitialAdDidClose:(DM_InterstitialAd *)interstitialAd{
    [self.view makeToast:[NSString stringWithFormat:@"interstitialAd被关闭了--%@",_interstitialAd.slotID]
                duration:3.0
                position:CSToastPositionCenter];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
///播放失败的回调
- (void)interstitialAdDidFailToShowWithError:(NSError *)error{
    [self.view makeToast:[NSString stringWithFormat:@"interstitialAd播放失败--%@",_interstitialAd.slotID]
                duration:3.0
                position:CSToastPositionCenter];
}

///视频播放完成
- (void)interstitialAdPlayToEndTime:(DM_InterstitialAd *)interstitialAd{
    [self.view makeToast:[NSString stringWithFormat:@"interstitialAd播放完成--%@",_interstitialAd.slotID]
                duration:3.0
                position:CSToastPositionCenter];
}
@end
