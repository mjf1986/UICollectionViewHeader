//
//  Four_ViewController.m
//  CZYTH_03
//
//  Created by yu on 15/8/21.
//  Copyright (c) 2015年 yu. All rights reserved.
//

#import "Four_ViewController.h"
#import "ReusableView.h"
#import "XLPlainFlowLayout.h"
#import "MJRefresh.h"

#define SCREEN_WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface Four_ViewController ()
/** 存放假数据 */
@property (strong, nonatomic) NSMutableArray *colors;
@end

@implementation Four_ViewController

static NSString *cellID = @"cellID";
static NSString *headerID = @"headerID";
static NSString *footerID = @"footerID";
static const CGFloat MJDuration = 1.0;
/**
 * 随机色
 */
#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
/**
 *  开始启动的时候调用，把init换掉
 *
 *  @param coder <#coder description#>
 *
 *  @return <#return value description#>
 */

#pragma mark - 示例
#pragma mark UICollectionView 上下拉刷新

- (void)languorefresh
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 增加5条假数据
        for (int i = 0; i < 5; i++) {
            [weakSelf.colors insertObject:MJRandomColor atIndex:0];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.mj_header endRefreshing];
        });
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 增加5条假数据
        for (int i = 0; i<5; i++) {
            [weakSelf.colors addObject:MJRandomColor];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.mj_footer endRefreshing];
        });
    }];
    // 默认先隐藏footer
    self.collectionView.mj_footer.hidden = YES;
}

#pragma mark - 数据相关
- (NSMutableArray *)colors
{
    if (!_colors) {
        self.colors = [NSMutableArray array];
    }
    return _colors;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{

    self = [super initWithCoder:coder];
    
    if (self) {
            XLPlainFlowLayout *layout = [XLPlainFlowLayout new];
            layout.itemSize = CGSizeMake(SCREEN_WIDTH / 2 - 15, (SCREEN_WIDTH / 2 - 15)*1.3);
            layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
            layout.naviHeight = 40.0;
        
            return [self initWithCollectionViewLayout:layout];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGRect a = self.view.frame;
    a.origin.y = 0;
    
    self.view.frame = a;
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));

    self.navigationItem.title = @"XLPlainFlowLayoutDemo";
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:headerID];
    [self.collectionView registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:footerID];
     [self performSelector:NSSelectorFromString(@"languorefresh") withObject:nil];
}

/**
 *  一组有多少个
 *
 *  @param collectionView <#collectionView description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/**
 *  一组有多少个
 *
 *  @param collectionView <#collectionView description#>
 *  @param section        <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   NSLog(@"%ld",self.colors.count);
    return self.colors.count;
}

/**
 *  cell里面的数据
 *
 *  @param collectionView collectionView description
 *  @param indexPath      indexPath description
 *
 *  @return return value description
 */
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    //cell.backgroundColor = indexPath.row%2?[UIColor redColor]:[UIColor blueColor];
    cell.backgroundColor = self.colors[indexPath.row];
    return cell;
}

/**
 *  头和尾巴的数据加载
 *
 *  @param collectionView collectionView description
 *  @param kind           kind description
 *  @param indexPath      indexPath description
 *
 *  @return return value description
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind==UICollectionElementKindSectionFooter) {
        ReusableView *footer = [collectionView  dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerID forIndexPath:indexPath];
        footer.backgroundColor = [UIColor yellowColor];
        footer.text = [NSString stringWithFormat:@"第%ld个分区的footer",indexPath.section];
//
        return footer;
    }
    
    if (indexPath.section >-1) {
        ReusableView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        
        header.backgroundColor = indexPath.section%2?[[UIColor blackColor] colorWithAlphaComponent:0.5] : [[UIColor blueColor] colorWithAlphaComponent:0.5];
        header.text = [NSString stringWithFormat:@"第%ld个分区的header",indexPath.section];

        return header;
    }
    return nil;
}

/**
 *  这个是头的距离（如果想隐藏就改成（0，0））
 *
 *  @param collectionView       <#collectionView description#>
 *  @param collectionViewLayout <#collectionViewLayout description#>
 *  @param section              <#section description#>
 *
 *  @return return value description
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{

    return CGSizeMake(0, 40);
}

/**
 *  这个是尾巴的距离（如果想隐藏就改成（0，0））
 *
 *  @param collectionView       <#collectionView description#>
 *  @param collectionViewLayout <#collectionViewLayout description#>
 *  @param section              <#section description#>
 *
 *  @return return value description
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
//    if (section==3) {
//        return CGSizeZero;
//    }
    return CGSizeZero;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}



@end
