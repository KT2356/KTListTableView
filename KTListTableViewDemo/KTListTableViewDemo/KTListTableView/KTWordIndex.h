//
//  KTWordIndex.h
//  KTListTableViewDemo
//
//  Created by KT on 15/12/7.
//  Copyright © 2015年 KT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTWordIndex : NSObject
+ (instancetype)sharedModel;

- (NSString *)getFirstLetter:(NSString *)word;
- (NSDictionary *)analysisDataList:(NSArray *)dataList;
@end
