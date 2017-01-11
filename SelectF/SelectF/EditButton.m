//
//  EditButton.m
//  SelectF
//
//  Created by daozhang on 17/1/11.
//  Copyright © 2017年 WLP. All rights reserved.
//

#import "EditButton.h"
#import "UIView+Extension.h"

@interface EditButton ()

@property (nonatomic,strong)UIControl *control;

@end

@implementation EditButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc]init];
        //self.imageView.backgroundColor = [UIColor redColor];
        [self addSubview:self.imageView];
        
        self.control = [[UIControl alloc]init];
        self.control.backgroundColor = [UIColor clearColor];
        [self addSubview:self.control];
    }
    return self;
}



- (void)setEditBtnSize:(CGSize)editBtnSize
{
    _editBtnSize = editBtnSize;
    self.size = editBtnSize;
    self.control.frame = self.bounds;
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self.control addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
