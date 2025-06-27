//
//  RewardVideoAdViewController.m
//  DMAd
//
//  Created by 刘士林 on 2024/3/27.
//

#import "RewardVideoAdViewController.h"
#import "UIView+Toast.h"

#import "DomobAdSDK/DMAds.h"
#import <DomobAdSDK/DM_RewardVideoAd.h>

static NSString *cellWithIdentifier = @"cellWithIdentifier";

@interface RewardVideoAdViewController ()<UITableViewDelegate,UITableViewDataSource,DMRewardVideoAdDelegate>
@property (nonatomic, strong) UITableView *listTable;
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, strong) DM_RewardVideoAd * rewardVideoAd;
@end

@implementation RewardVideoAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];;
    self.titleArr= @[@"激励视频",];
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
    
        self.rewardVideoAd = [[DM_RewardVideoAd new] loadRewardVideoAdTemplateAdWithSlotID:@"124191739261623013170904"  delegate:self];
}
#pragma  ---DMRewardVideoAdDelegate
- (void)rewardVideoAdDidClick:(nonnull DM_RewardVideoAd *)rewardVideoAd {
    [self.listTable reloadData];
    [self.view makeToast:[NSString stringWithFormat:@"rewardVideoAd被点击--%@",_rewardVideoAd.materialId]
                duration:3.0
                position:CSToastPositionCenter];
}
- (void)rewardVideoAdDidFailToLoadWithError:(nonnull NSError *)error {
    [self.view makeToast:[NSString stringWithFormat:@"rewardVideoAd加载失败--%@",_rewardVideoAd.materialId]
                duration:3.0
                position:CSToastPositionCenter];

}

- (void)rewardVideoAdDidFailToRenderWithError:(nonnull NSError *)error {
    [self.view makeToast:[NSString stringWithFormat:@"rewardVideoAd渲染失败--%@",_rewardVideoAd.materialId]
                duration:3.0
                position:CSToastPositionCenter];
}

- (void)rewardVideoAdDidLoad:(nonnull DM_RewardVideoAd *)rewardVideoAd {
    [self.view makeToast:[NSString stringWithFormat:@"rewardVideoAd加载成功--%@",_rewardVideoAd.materialId]
                duration:3.0
                position:CSToastPositionCenter];
    [rewardVideoAd biddingRewardVideoFailed:1800 Code:104];
    [rewardVideoAd biddingRewardVideoSuccess:10001];
}

- (void)rewardVideoAdDidRender:(nonnull DM_RewardVideoAd *)rewardVideoAd {
    [self.view makeToast:[NSString stringWithFormat:@"rewardVideoAd渲染成功--%@",_rewardVideoAd.materialId]
                duration:3.0
                position:CSToastPositionCenter];
    //渲染成功后已经将view返回
    //可以将view展示在当前的视图上
    self.rewardVideoAd = rewardVideoAd;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.rewardVideoAd showRewardVideoViewInRootViewController:self];
}

- (void)rewardVideoAdDidShow:(nonnull DM_RewardVideoAd *)rewardVideoAd {
    [self.listTable reloadData];
    [self.view makeToast:[NSString stringWithFormat:@"rewardVideoAd已经开始展示--%@",_rewardVideoAd.materialId]
                duration:3.0
                position:CSToastPositionCenter];
}
/// 广告被关闭
- (void)rewardVideoAdDidClose:(DM_RewardVideoAd *)rewardVideoAd{
    [self.view makeToast:[NSString stringWithFormat:@"rewardVideoAd被关闭了--%@",_rewardVideoAd.materialId]
                duration:3.0
                position:CSToastPositionCenter];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)rewardVideoAdDidComplete:(DM_RewardVideoAd *)rewardVideoAd{
    [self.view makeToast:[NSString stringWithFormat:@"rewardVideoAd发奖了--%@",_rewardVideoAd.materialId]
                duration:3.0
                position:CSToastPositionCenter];
}
///播放失败的回调
- (void)rewardVideoAdDidFailToShowWithError:(NSError *)error{
    [self.view makeToast:[NSString stringWithFormat:@"rewardVideoAd播放失败--%@",_rewardVideoAd.materialId]
                duration:3.0
                position:CSToastPositionCenter];
}

///视频播放完成
- (void)rewardVideoAdPlayToEndTime:(DM_RewardVideoAd *)rewardVideoAd{
    [self.view makeToast:[NSString stringWithFormat:@"rewardVideoAd播放完成--%@",_rewardVideoAd.materialId]
                duration:3.0
                position:CSToastPositionCenter];
}
@end
