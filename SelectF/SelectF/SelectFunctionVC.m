//
//  SelectFunctionVC.m
//  SelectF
//
//  Created by daozhang on 17/1/8.
//  Copyright © 2017年 WLP. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface ItemPoint : NSObject

@property (nonatomic,assign)CGFloat x;
@property (nonatomic,assign)CGFloat y;

@end

@implementation ItemPoint

+ (ItemPoint*)initItemPointWithX:(CGFloat)x Y:(CGFloat)y
{
    ItemPoint *point = [[ItemPoint alloc]init];
    point.x = x;
    point.y = y;
    return point;
}

@end


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define BackGroundColor  R_G_B_16(0xf0f0f0)     //背景灰
// RGB颜色转换（16进制->10进制）
#define R_G_B_16(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define mineFunctionArrPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"mineFunctionArr.data"]
#define recommendFunctionArrPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recommendFunctionArr.data"]

#import "SelectFunctionVC.h"
#import "CollectionSectionHeader.h"
#import "SelectFunctionCell.h"
#import "SelectFunctionInfo.h"
#import "UIView+Extension.h"


@interface SelectFunctionVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray *mineFunctionArr;  //存放我的应用
@property (nonatomic,strong) NSMutableArray *recommendFunctionArr; //推荐应用
@property (nonatomic,assign) BOOL isEditStatu;   //是否是编辑状态
@property (nonatomic,assign) BOOL isAniamEffect; //是否需要动画效果
@property (nonatomic,strong) UIBarButtonItem *rigthItem;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIPanGestureRecognizer *longPressRemoveGes;//长按移动手势
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressEdit;     //长按进入编辑手势
@property (nonatomic,strong) NSMutableArray *postionPointArr;

@end

@implementation SelectFunctionVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackGroundColor;
    
    self.rigthItem = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = self.rigthItem;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //长按进入编辑手势
    self.longPressEdit = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressEdit:)];
    self.longPressEdit.minimumPressDuration = 1;
    [self.collectionView addGestureRecognizer:self.longPressEdit];
    
    //长按移动Item手势
    self.longPressRemoveGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(removeLongPressGesture:)];
    
    //段头
    [self.collectionView registerClass:[CollectionSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionSectionHeader"];
    //段尾
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionSectionFooter"];
    
    //设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.userInteractionEnabled = YES;
    
    //注册cell
    [self.collectionView registerClass:[SelectFunctionCell class] forCellWithReuseIdentifier:@"firstCell"];
    [self.view addSubview:self.collectionView];
    
    //读取沙盒的存储
    NSArray *mineFunctionArr = [NSKeyedUnarchiver unarchiveObjectWithFile:mineFunctionArrPath];
    NSArray *recommendFunctionArr = [NSKeyedUnarchiver unarchiveObjectWithFile:recommendFunctionArrPath];
    NSLog(@"%@---%@",mineFunctionArrPath,recommendFunctionArrPath);
    if (mineFunctionArr != nil && recommendFunctionArr != nil)
    {
        self.mineFunctionArr = [NSMutableArray arrayWithArray:mineFunctionArr];
        self.recommendFunctionArr = [NSMutableArray arrayWithArray:recommendFunctionArr];
    }else{
        
        self.mineFunctionArr = [[NSMutableArray alloc]init];
        self.recommendFunctionArr = [[NSMutableArray alloc]init];
        //读取本地plist 文件
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Function" ofType:@"plist"];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
        NSMutableArray *dataSources = [[NSMutableArray alloc]init];
        for (NSDictionary *temDic in array)
        {
            SelectFunctionInfo *info = [[SelectFunctionInfo alloc]init];
            info.itemTitle = temDic[@"itemTitle"];
            info.itemImgStr = temDic[@"itemImgStr"];
            [dataSources addObject:info];
        }
        
        for (SelectFunctionInfo *functionInf in dataSources)
        {
            if ([functionInf.itemTitle isEqualToString:@"转账"]||[functionInf.itemTitle isEqualToString:@"信用卡还款"]||[functionInf.itemTitle isEqualToString:@"充值中心"]||[functionInf.itemTitle isEqualToString:@"余额宝"]||[functionInf.itemTitle isEqualToString:@"淘票票"]||[functionInf.itemTitle isEqualToString:@"滴滴出行"]||[functionInf.itemTitle isEqualToString:@"生活缴费"]||[functionInf.itemTitle isEqualToString:@"蚂蚁花呗"])
            {
                functionInf.isExist = YES;
                [self.mineFunctionArr addObject:functionInf];
            }else{
                functionInf.isExist = NO;
                [self.recommendFunctionArr addObject:functionInf];
            }
        }
    }
    
    self.isEditStatu = NO;   //默认不是编辑状态
    self.isAniamEffect = NO; //默认不需要动画效果
    self.postionPointArr = [NSMutableArray array];
    CGFloat itemWithHeight = (kScreenWidth - 20 - 3*10)/4.0;
    ItemPoint *firstPoint = [ItemPoint initItemPointWithX:itemWithHeight/2.0 Y:itemWithHeight/2.0 + 40]; //断头高40
    [self.postionPointArr addObject:firstPoint];
    
}

#pragma mark - UICollectionViewDataSource
#pragma mark 设置每个区的cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.mineFunctionArr.count;
    }else{
        return self.recommendFunctionArr.count;
    }
}

#pragma mark - 每个段头的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (self.mineFunctionArr.count == 0 && section == 0) //我的应用无选择功能时
    {
        return CGSizeMake(self.view.frame.size.width, 40 + 75);
    }
    return CGSizeMake(self.view.frame.size.width, 40);
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
   return CGSizeMake(self.view.frame.size.width, 16);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        CollectionSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionSectionHeader" forIndexPath:indexPath];
        if (indexPath.section == 0 && self.mineFunctionArr.count == 0)
        {//只有第一区在没有选择功能板块的时候才出现提示
            header.notingView.hidden = NO;
            header.isEditStatu = self.isEditStatu;
        }else {
            header.notingView.hidden = YES;
        }
        
        if (indexPath.section == 0)
        {
            header.sectionTilLabel.text = @"我的应用";
        } else {
            header.sectionTilLabel.text = @"我的推荐";
        }
        return header;
    }
    
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionSectionFooter" forIndexPath:indexPath];
    footer.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        footer.backgroundColor = BackGroundColor;
    }
    return footer;
   
}

#pragma mark 设置cell（cell for row）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectFunctionCell *firstCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"firstCell" forIndexPath:indexPath];
    
    CGFloat itemWithHeight = (kScreenWidth - 20 - 3*10)/4.0;
    firstCell.itemSize = CGSizeMake(itemWithHeight, itemWithHeight);
    firstCell.isAniamEffect = self.isAniamEffect;
    firstCell.isEditStude = self.isEditStatu;
    
    if (indexPath.section == 0)
    {
        SelectFunctionInfo *info = self.mineFunctionArr[indexPath.row];
        [firstCell configCellWithPicture:info indxPath:indexPath];
    }else{
        SelectFunctionInfo *inf = self.recommendFunctionArr[indexPath.row];
        [firstCell configCellWithPicture:inf indxPath:indexPath];
    }
    
    WS(ws);
    [firstCell setItemButtonClickBlock:^{
        
        ws.isAniamEffect = NO;
        if (indexPath.section == 0) //点击第一区的item的减号
        {
            SelectFunctionInfo *info = ws.mineFunctionArr[indexPath.row];
            info.isExist = NO;
            [ws.recommendFunctionArr addObject:info];
            SelectFunctionCell *cell = (SelectFunctionCell*)[ws.collectionView cellForItemAtIndexPath:indexPath];
            cell.alpha = 1;
            [UIView animateWithDuration:0.3 animations:^{
                
                cell.alpha = 0;
                cell.transform = CGAffineTransformMakeScale(0.1, 0.1);
            } completion:^(BOOL finished) {
                
                cell.transform = CGAffineTransformIdentity;
                cell.alpha = 1;
                [ws.mineFunctionArr removeObjectAtIndex:indexPath.row];
                [ws.collectionView reloadData];
            }];
            
        } else { //点击第一区的item的加号

            SelectFunctionInfo *info = ws.recommendFunctionArr[indexPath.row];
            info.isExist = YES;
            [ws.mineFunctionArr addObject:info];
            
            SelectFunctionCell *cell = (SelectFunctionCell*)[ws.collectionView cellForItemAtIndexPath:indexPath];
            cell.alpha = 1;
            [UIView animateWithDuration:0.5 animations:^{
                
                cell.alpha = 0;
                //计算上面将要添加的item位置
                ItemPoint *point =  ws.postionPointArr.lastObject;
                CGFloat x = point.x - cell.centerX;
                CGFloat y = point.y - cell.centerY;
                cell.transform = CGAffineTransformMakeTranslation(x, y);
                
            } completion:^(BOOL finished) {
                
                cell.alpha = 1;
                [ws.recommendFunctionArr removeObjectAtIndex:indexPath.row];
                [ws.collectionView reloadData];
            }];
        }
    }];
    return firstCell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
   
    CGFloat itemWithHeight = (kScreenWidth - 20 - 3*10)/4.0;
    NSLog(@"itemWithHeight/2=%f,cellCenterX=%f,cellCenterY=%f",itemWithHeight/2,cell.center.x,cell.center.y);
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self.postionPointArr removeAllObjects];
        }
        ItemPoint *point = [ItemPoint initItemPointWithX:cell.center.x Y:cell.center.y];
        [self.postionPointArr addObject:point];
        NSInteger count = self.mineFunctionArr.count;
        if (indexPath.row == count -1) //最后一个
        {
            CGFloat itemWithHeight = (kScreenWidth - 20 - 3*10)/4.0;
            if (count%4 == 0) //4的倍数个,下一个放下一行第一个
            {
                ItemPoint *point1 = self.postionPointArr[0];
                ItemPoint *lastPoint = [ItemPoint initItemPointWithX:point1.x Y:point.y + itemWithHeight + 10];
                [self.postionPointArr addObject:lastPoint];
            }else{
                ItemPoint *lastPoint = [ItemPoint initItemPointWithX:point.x +   itemWithHeight + 10 Y:point.y];
                [self.postionPointArr addObject:lastPoint];
            }
        }
        
    }

}





#pragma mark 设置分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//下面4个代理方法可以用UICollectionViewFlowLayout的类里的属性设置，效果应该一样，我习惯用代理方法
#pragma mark 设置每个Item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //每区左右10 每个item之间10 上下5
    CGFloat itemWithHeight = (kScreenWidth - 20 - 3*10)/4.0;
    return CGSizeMake(itemWithHeight, itemWithHeight);
}

#pragma mark 设置Section的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //UIEdgeInsetsMake的四个参数是（上，左，下，右）
    return UIEdgeInsetsMake(0, 10,20, 10);
    
}

#pragma mark 设置每个Section里面各个Item的水平距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    //每个item之间10 上下5
    return  10;
}

#pragma mark 设置每行Item之间的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}


#pragma mark 选取某个cell，点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSLog(@"丑得上天了");
    }else{
        NSLog(@"丑得下地了");
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //只有第一区才能移动且
    if (indexPath.section == 0)
    {
        return YES;
    }
    return NO;
    
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    if (sourceIndexPath.section == 0 && destinationIndexPath.section == 0)
    {
        //数据源交换
        [self.mineFunctionArr exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        
    }else{
        
        [collectionView moveItemAtIndexPath:destinationIndexPath  toIndexPath:sourceIndexPath];
    }
}


#pragma mark 导航栏右按钮事件
- (void)edit:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:@"管理"]) //进入编辑状态
    {
        self.isEditStatu = YES;
        self.isAniamEffect = YES;
        [self.collectionView reloadData];
        self.rigthItem.title = @"完成";
        [self.collectionView removeGestureRecognizer:self.longPressEdit]; //进入编辑不需要长按编辑了
        [self.collectionView addGestureRecognizer:self.longPressRemoveGes];//进入编辑添加移动手势
        
    }else if ([sender.title isEqualToString:@"完成"]) //完成编辑
    {
        self.isEditStatu = NO;
        self.isAniamEffect = YES;
        [self.collectionView reloadData];
        self.rigthItem.title = @"管理";
        [self.collectionView addGestureRecognizer:self.longPressEdit]; //完成编辑需要长按编辑手势
        [self.collectionView removeGestureRecognizer:self.longPressRemoveGes];//完成编辑不需要移动手势了
        //归档model数组 存沙盒
        [NSKeyedArchiver archiveRootObject:self.mineFunctionArr toFile:mineFunctionArrPath];
        [NSKeyedArchiver archiveRootObject:self.recommendFunctionArr toFile:recommendFunctionArrPath];
//        NSLog(@"mineFunctionArr=%@", mineFunctionArrPath);
//        NSLog(@"recommendFunctionArr=%@", recommendFunctionArrPath);
    }
}


- (void)longPressEdit:(UILongPressGestureRecognizer *)longGesture //长按进入编辑状态
{
    //判断手势状态
    switch (longGesture.state) {
            
        case UIGestureRecognizerStateBegan:
        {
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            NSLog(@"%@", indexPath);

            if (indexPath != nil)
            {
                self.isEditStatu = YES;
                self.isAniamEffect = YES;
                [self.collectionView reloadData];
                self.rigthItem.title = @"完成";
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self.collectionView removeGestureRecognizer:longGesture];
            [self.collectionView addGestureRecognizer:self.longPressRemoveGes];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 移动长按手势
- (void)removeLongPressGesture:(UIPanGestureRecognizer *)longGesture
{
    CGPoint pressPoint = [longGesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pressPoint];
    //判断手势状态
    switch (longGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            if (indexPath != nil)
            {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
                SelectFunctionCell *cell = (SelectFunctionCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
                cell.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (indexPath != nil)
            {
                 [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
                SelectFunctionCell *cell = (SelectFunctionCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
                cell.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self.collectionView endInteractiveMovement];
            break;
        }
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
