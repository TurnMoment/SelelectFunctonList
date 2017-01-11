//
//  CollectionSectionHeader.m
//  SelectF
//
//  Created by daozhang on 17/1/8.
//  Copyright © 2017年 WLP. All rights reserved.
//
// RGB颜色转换（16进制->10进制）
#define R_G_B_16(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define Font_SecondaryTitle  (13)   //次要标题



#import "CollectionSectionHeader.h"
#import "UIView+Extension.h"

@interface CollectionSectionHeader ()

@property (nonatomic,strong)UILabel *notingLabel2;

@end

@implementation CollectionSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat itemWithHeight = (kScreenWidth - 20 - 3*10)/4.0; //item的宽度
        self.sectionTilLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,8, itemWithHeight, 30)];
        self.sectionTilLabel.textAlignment = NSTextAlignmentCenter;
        self.sectionTilLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.sectionTilLabel];
        
        self.notingView = [[UIView alloc]initWithFrame:CGRectMake(0, self.sectionTilLabel.bottom, kScreenWidth, 75)];
        self.notingView.hidden = YES;
        [self addSubview:self.notingView];
        
        UILabel *notingLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.notingView.height/2.0 - 10, kScreenWidth, 15)];
        notingLabel1.textColor = R_G_B_16(0xc8c7cd);
        notingLabel1.text = @"您还未添加任何应用";
        notingLabel1.textAlignment = NSTextAlignmentCenter;
        notingLabel1.font = [UIFont systemFontOfSize:Font_SecondaryTitle];
        [self.notingView addSubview:notingLabel1];
        
        UILabel *notingLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, notingLabel1.bottom, kScreenWidth, 15)];
        self.notingLabel2 = notingLabel2;
        notingLabel2.textColor = R_G_B_16(0xc8c7cd);
        notingLabel2.text = @"长按下面的应用可以添加";
        notingLabel2.textAlignment = NSTextAlignmentCenter;
        notingLabel2.font = [UIFont systemFontOfSize:Font_SecondaryTitle];
        [self.notingView addSubview:notingLabel2];
        
    }
    return self;
}

- (void)setIsEditStatu:(BOOL)isEditStatu
{
    _isEditStatu = isEditStatu;
    if (isEditStatu) {
        self.notingLabel2.text = @"点击加号按钮可添加应用";
    } else {
        self.notingLabel2.text = @"长按下面的应用可以添加";
    }

}


@end
