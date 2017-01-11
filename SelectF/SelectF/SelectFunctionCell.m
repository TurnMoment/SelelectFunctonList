//
//  SelectFunctionCell.m
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

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define kScreenWidth [UIScreen mainScreen].bounds.size.width


#import "SelectFunctionCell.h"
#import "UIView+Extension.h"
#import "EditButton.h"

@interface SelectFunctionCell ()

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
//@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) EditButton *editBtn;

@end


@implementation SelectFunctionCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,25, 25)];
        self.imgView.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0 - 12);
        [self.contentView addSubview:self.imgView];
        
        self.editBtn = [[EditButton alloc]init];
        self.editBtn.hidden = YES;
        self.editBtn.editBtnSize = CGSizeMake(25, 25);
        self.editBtn.center = CGPointMake(frame.size.width - 12.5,12.5);
        [self.editBtn addTarget:self action:@selector(editBtnClick:)];
        [self.contentView addSubview:self.editBtn];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.imgView.bottom + 13,frame.size.width, 17)];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)configCellWithPicture:(SelectFunctionInfo *)info indxPath:(NSIndexPath *)indexpath
{
    self.imgView.image = [UIImage imageNamed:info.itemImgStr];
    self.titleLabel.text = info.itemTitle;
    //self.indexPath = indexpath;
    if (info.isExist) {
        self.editBtn.imageView.image = [UIImage imageNamed:@"loss"];
    }else{
        self.editBtn.imageView.image = [UIImage imageNamed:@"add"];
    }
    self.imgView.contentMode = UIViewContentModeCenter;
}


- (void)setIsEditStude:(BOOL)isEditStude
{
    _isEditStude = isEditStude;
    if (isEditStude) { //是编辑状态
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = R_G_B_16(0xc8c7cd).CGColor;
        self.editBtn.hidden = NO;
        if (self.isAniamEffect) {
            
            self.editBtn.imageView.size = CGSizeMake(1, 1);
            self.editBtn.imageView.center = CGPointMake(25/2.0, 25/2.0);
            self.editBtn.alpha = 0;
            WS(ws);
            [UIView animateWithDuration:0.3 animations:^{
                
                ws.editBtn.alpha = 1;
                ws.editBtn.imageView.transform = CGAffineTransformScale(ws.editBtn.imageView.transform, 15, 15);
            }];
        }
//        else {
//            self.editBtn.size = CGSizeMake(25, 25);
//            self.editBtn.center = CGPointMake(self.itemSize.width - 12.5,12.5);
//            self.editBtn.alpha = 1;
//        }
        
    } else { //取消编辑状态
        
        self.editBtn.imageView.size = CGSizeMake(15, 15);
        self.editBtn.imageView.center = CGPointMake(12.5, 12.5);
        if (self.isAniamEffect)
        {
            self.editBtn.alpha = 1;
            WS(ws);
            [UIView animateWithDuration:0.3 animations:^{
                
                ws.editBtn.alpha = 0;
                self.layer.borderWidth = 0;
                ws.editBtn.imageView.transform = CGAffineTransformScale(ws.editBtn.transform, 1.0/15, 1.0/15);

            } completion:^(BOOL finished) {
                
                ws.editBtn.imageView.size = CGSizeMake(15, 15);
                ws.editBtn.hidden = YES;
            }];
            
        } else {
            self.editBtn.hidden = YES;
            self.layer.borderWidth = 0;
        }
        
    }
}


- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
}

- (void)editBtnClick:(UIButton*)sender
{
    self.itemButtonClickBlock();
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
