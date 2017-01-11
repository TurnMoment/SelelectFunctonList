//
//  SelectFunctionCell.h
//  SelectF
//
//  Created by daozhang on 17/1/8.
//  Copyright © 2017年 WLP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectFunctionInfo.h"

@interface SelectFunctionCell : UICollectionViewCell

@property (nonatomic,assign)BOOL isAniamEffect;
@property (nonatomic,assign)BOOL isEditStude;
@property (nonatomic,assign) CGSize itemSize;

- (void)configCellWithPicture:(SelectFunctionInfo *)info indxPath:(NSIndexPath *)indexpath;

@property (nonatomic,copy)void (^itemButtonClickBlock)();



@end
