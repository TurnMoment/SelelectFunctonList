//
//  EditButton.h
//  SelectF
//
//  Created by daozhang on 17/1/11.
//  Copyright © 2017年 WLP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface EditButton : UIView


@property (nonatomic,assign)CGSize editBtnSize;

@property (nonatomic,strong)UIImageView *imageView;

- (void)addTarget:(id)target action:(SEL)action;

@end
