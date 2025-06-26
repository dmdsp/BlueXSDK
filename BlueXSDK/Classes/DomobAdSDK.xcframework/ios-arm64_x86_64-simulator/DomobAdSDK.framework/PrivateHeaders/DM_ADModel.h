//
//  DM_ADModel.h
///  DMAd
//
//  Created by 刘士林 on 2024/3/14.
//

#import <Foundation/Foundation.h>
#import "DM_CreativeModel.h"


@interface DM_ADModel : NSObject

@property (nonatomic, strong) NSMutableArray<NSString *> *impressions;
@property (nonatomic, strong) DM_CreativeModel *videoModel;
@property (nonatomic, strong) DM_CreativeModel *bannerModel;

@end
