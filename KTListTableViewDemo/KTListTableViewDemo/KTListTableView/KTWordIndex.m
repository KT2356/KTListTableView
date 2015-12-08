//
//  KTWordIndex.m
//  KTListTableViewDemo
//
//  Created by KT on 15/12/7.
//  Copyright © 2015年 KT. All rights reserved.
//

#import "KTWordIndex.h"
#import "KTListDataModel.h"
#import "pinyin.h"
@interface KTWordIndex()
@property (nonatomic, strong) NSMutableDictionary *dataDict;
@end

@implementation KTWordIndex

+ (instancetype)sharedModel {
    static dispatch_once_t onceToken;
    static KTWordIndex *wordIndex;
    dispatch_once(&onceToken, ^{
        wordIndex = [[KTWordIndex alloc] init];
    });
    return wordIndex;
}

- (NSString *)getFirstLetter:(NSString *)word {
    NSString *pinyinLetter;
    NSString *subString = [word substringWithRange:NSMakeRange(0,1)];
    const char *cString = [subString UTF8String];
    //汉字
    if (strlen(cString) == 3) {
        pinyinLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([word characterAtIndex:0])]uppercaseString];
    }
    else {
        pinyinLetter = [subString uppercaseString];
        NSString *regex = @"[A-Z]";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if (![predicate evaluateWithObject:pinyinLetter]) {
            pinyinLetter = @"#";
        }
    }
    return pinyinLetter;
}


/**
 *  @author KT, 2015-12-08 17:32:40
 *
 *  数组转字典

 */
- (NSDictionary *)analysisDataList:(NSArray *)dataList {
    for (KTListDataModel *model in dataList) {
        NSString *index = [self getFirstLetter:model.userName];
        if (![[self.dataDict allKeys] containsObject:index]) {
            [self.dataDict setObject:@[model] forKey:index];
        } else {
            NSMutableArray *dataArray = [[self.dataDict valueForKey:index] mutableCopy];
            [dataArray addObject:model];
            [self.dataDict setObject:dataArray forKey:index];
        }
    }
    return self.dataDict;
}

- (NSMutableDictionary *)dataDict {
    if (!_dataDict) {
        _dataDict = [@{} mutableCopy];
    }
    return _dataDict;
}
@end
