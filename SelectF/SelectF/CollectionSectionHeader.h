//
//  CollectionSectionHeader.h
//  SelectF
//
//  Created by daozhang on 17/1/8.
//  Copyright © 2017年 WLP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionSectionHeader : UICollectionReusableView

@property (nonatomic,strong)UILabel *sectionTilLabel;

@property(nonatomic,strong)UIView *notingView;   //提示文字

@property (nonatomic,assign)BOOL isEditStatu;    //collectView是否是编辑状态

@end
