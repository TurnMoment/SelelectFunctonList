//
//  SelectFunctionInfo.m
//  SelectF
//
//  Created by daozhang on 17/1/8.
//  Copyright © 2017年 WLP. All rights reserved.
//

#import "SelectFunctionInfo.h"
#import "MJExtension.h"

@implementation SelectFunctionInfo

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{

}

/**
 *  将对象写入文件的时候调用
 */

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [self mj_encode:encoder];
}
/**
 *  从文件中解析对象的时候调
 */
- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        [self mj_decode:decoder];
    }
    return self;
}



@end
