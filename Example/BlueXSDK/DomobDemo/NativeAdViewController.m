//
//  NativeAdViewController.m
//  DomobSDK
//
//  Created by 刘士林 on 2025/2/25.
//

#import "NativeAdViewController.h"
#import "UIView+Toast.h"

#import <DomobAdSDK/DMAds.h>
#import <DomobAdSDK/DM_NativeAd.h>

static NSString *cellWithIdentifier = @"cellWithIdentifier";

@interface NativeAdViewController ()<UITableViewDelegate,UITableViewDataSource,DMNativeAdLoadDelegate>
@property (nonatomic, strong) UITableView *listTable;

@property (nonatomic, copy) NSArray *titleArr;

@property (nonatomic, strong) DM_NativeAd * nativeAd;

@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];;
    self.titleArr= @[@"加载广告"];
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
    self.nativeAd =  [[DM_NativeAd alloc] init];
    [self.nativeAd loadNativeAdTemplateAdWithSlotID:@"124191739773988116008475" delegate:self];
}
- (void)nativeAdDidFailToLoadWithError:(nonnull NSError *)error { 
    
}
#pragma mark - DMNativeAdLoadDelegate
- (void)nativeAdDidLoad:(nonnull DM_NativeAd *)nativeAd {
    self.nativeAd = nativeAd;
    DM_NativeView * nativeAdView = [[DM_NativeView alloc] initWithFrame:CGRectMake(50, 100, 300, 200)];
    
    UIImageView * adImg = [[UIImageView alloc]initWithFrame:nativeAdView.bounds];
    [nativeAdView addSubview:adImg];
    adImg.backgroundColor = [UIColor grayColor];
    adImg.contentMode = UIViewContentModeScaleToFill;
    // 使用示例
    [self loadImageFromURL:self.nativeAd.nativeModel.imgUrl completion:^(UIImage *image) {
        if (image) {
            // 在主线程上更新 UI
            adImg.image = image;
        }
    }];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 40)];
    label.text = self.nativeAd.nativeModel.btnText;
    [nativeAdView addSubview:label];
    [self.nativeAd registerContainer:nativeAdView];
    [self.nativeAd registerClickableViews:@[label]];
    [self.view addSubview:nativeAdView];

}
/// 广告已经打开
- (void)nativeAdDidShow:(DM_NativeAd *)nativeAd{
    [self.view makeToast:[NSString stringWithFormat:@"nativeAd已经开始展示"]
                duration:3.0
                position:CSToastPositionCenter];
}
/// 广告被点击
- (void)nativeAdDidClick:(DM_NativeAd *)nativeAd{
    [self.view makeToast:[NSString stringWithFormat:@"nativeAd被点击"]
                duration:3.0
                position:CSToastPositionCenter];
}
- (void)loadImageFromURL:(NSString *)urlString completion:(void (^)(UIImage *image))completion {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error loading image: %@", error.localizedDescription);
            completion(nil);
            return;
        }
        
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    }];
    
    [dataTask resume];
}
@end
