//
//  SelectFunctionInfo.h
//  SelectF
//
//  Created by daozhang on 17/1/8.
//  Copyright © 2017年 WLP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectFunctionInfo : NSObject

@property (nonatomic,copy)NSString *itemTitle;
@property (nonatomic,copy)NSString *itemImgStr;
@property (nonatomic,assign)BOOL isExist;      //是否已经选择这个功能在应用区



@end
