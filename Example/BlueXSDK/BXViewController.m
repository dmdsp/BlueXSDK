//
//  BXViewController.m
//  BlueXSDK
//
//  Created by dmdsp on 06/26/2025.
//  Copyright (c) 2025 dmdsp. All rights reserved.
//

#import "BXViewController.h"

#import "SplashAViewController.h"
#import "ALBannerViewController.h"
#import "TradplusDemoViewController.h"
#import "ToponSplashViewController.h"
#import "AdmobDemoViewController.h"


static NSString *cellWithIdentifier = @"cellWithIdentifier";

@interface BXViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *listTable;
@property (nonatomic, copy) NSArray *titleArr;

@end

@implementation BXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleArr= @[@"多盟海外",@"Max聚合",@"TradPlus聚合",@"Topon聚合",@"Admob聚合"];
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
    if(indexPath.row == 0){
        SplashAViewController * splash = [[SplashAViewController alloc]init];
        [self.navigationController pushViewController:splash animated:YES];
    }else if (indexPath.row == 1){
        ALBannerViewController * alBanner = [[ALBannerViewController alloc]init];
        [self.navigationController pushViewController:alBanner animated:YES];
    }else if (indexPath.row == 2){
        TradplusDemoViewController * tradplusDemo = [[TradplusDemoViewController alloc]init];
        [self.navigationController pushViewController:tradplusDemo animated:YES];
    }else if (indexPath.row == 3){
        ToponSplashViewController * toponDemo = [[ToponSplashViewController alloc]init];
        [self.navigationController pushViewController:toponDemo animated:YES];
    }else if (indexPath.row == 4){
        AdmobDemoViewController * admobDemo = [[AdmobDemoViewController alloc]init];
        [self.navigationController pushViewController:admobDemo animated:YES];
    }
   
}

@end
