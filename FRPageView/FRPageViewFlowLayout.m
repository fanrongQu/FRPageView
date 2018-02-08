//
//  FRPageViewFlowLayout.m
//  FRPageView
//
//  Created by mac on 2017/7/28.
//  Copyright © 2017年 fanrongQu. All rights reserved.
//

#import "FRPageViewFlowLayout.h"

@implementation FRPageViewFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.itemScale = 1.0;
    }
    return self;
}

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 1.prepareLayout
 2.layoutAttributesForElementsInRect:方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGFloat)cellWidth {
    if (self.itemScale == 1.0) {
        return self.collectionView.bounds.size.width;
    }
    return self.collectionView.bounds.size.width * self.itemScale - self.itemSpacing * (1 - self.itemScale);
}

/**
 * 用来做布局的初始化操作（不建议在init方法中进行布局的初始化操作）
 */
- (void)prepareLayout
{
    [super prepareLayout];
    // 水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGSize size = self.collectionView.frame.size;
    if (self.itemScale == 1.0) {
        self.itemSize = size;
        self.minimumLineSpacing = self.itemSpacing;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, self.itemSpacing);
        return;
    }
    self.itemSize = CGSizeMake(size.width * self.itemScale, size.height * self.itemScale);
    CGFloat margin = - self.itemSpacing * (1 - self.itemScale);
    self.minimumLineSpacing = margin;
    self.sectionInset = UIEdgeInsetsMake(0, margin/2, 0, margin/2);
}

/**
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 */
/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect] ;

    // 计算collectionView最中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;

    // 在原有布局属性的基础上，进行微调
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // cell的中心点x 和 collectionView最中心点的x值 的间距
        CGFloat delta = ABS(attrs.center.x - centerX);
        delta = MIN(delta, self.itemSize.width);
        // 根据间距值 计算 cell的缩放比例
        CGFloat scale = 1 - delta / self.itemSize.width;
        scale = scale > self.itemScale?scale:self.itemScale;
        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}

///**
// * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
// */
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    // 计算出最终显示的矩形框
//    CGRect rect;
//    rect.origin.y = 0;
//    rect.origin.x = proposedContentOffset.x;
//    rect.size = self.collectionView.frame.size;
//
//    // 获得super已经计算好的布局属性
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//
//    // 计算collectionView最中心点的x值
//    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
//
//    // 存放最小的间距值
//    CGFloat minDelta = MAXFLOAT;
//    for (UICollectionViewLayoutAttributes *attrs in array) {
//        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
//            minDelta = attrs.center.x - centerX;
//        }
//    }
//    // 修改原有的偏移量
//    proposedContentOffset.x += minDelta;
//    return proposedContentOffset;
//}

- (void)setItemScale:(CGFloat)itemScale {
    _itemScale = itemScale;
    if (!_itemSpacing && itemScale != 1) {//为cell等比例缩放时设置默认间距
        _itemSpacing = 50;
    }
}

@end
