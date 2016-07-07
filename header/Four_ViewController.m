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


@interface Four_ViewController ()

@end

@implementation Four_ViewController

static NSString *cellID = @"cellID";
static NSString *headerID = @"headerID";
static NSString *footerID = @"footerID";

/**
 *  开始启动的时候调用，把init换掉
 *
 *  @param coder <#coder description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{

    self = [super initWithCoder:coder];
    
    if (self) {
            XLPlainFlowLayout *layout = [XLPlainFlowLayout new];
            layout.itemSize = CGSizeMake(100, 100);
            layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
            layout.naviHeight = 44.0;
        
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
    return 10;
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
  
    return 10;
}

/**
 *  cell里面的数据
 *
 *  @param collectionView <#collectionView description#>
 *  @param indexPath      <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = indexPath.section%2?[UIColor redColor]:[UIColor cyanColor];
    return cell;
}

/**
 *  头和尾巴的数据加载
 *
 *  @param collectionView <#collectionView description#>
 *  @param kind           <#kind description#>
 *  @param indexPath      <#indexPath description#>
 *
 *  @return <#return value description#>
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
 *  @return <#return value description#>
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{

    return CGSizeMake(0, 44);
}

/**
 *  这个是尾巴的距离（如果想隐藏就改成（0，0））
 *
 *  @param collectionView       <#collectionView description#>
 *  @param collectionViewLayout <#collectionViewLayout description#>
 *  @param section              <#section description#>
 *
 *  @return <#return value description#>
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
//    if (section==3) {
//        return CGSizeZero;
//    }
    return CGSizeMake(0, 44);
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}



@end
