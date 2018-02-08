//
//  FRPageView.m
//  FRPageView
//
//  Created by mac on 2017/7/25.
//  Copyright © 2017年 fanrongQu. All rights reserved.
//

#import "FRPageView.h"
#import "FRPageViewFlowLayout.h"

/** 顶部轮播广告的最大sections */
static CGFloat const MaxSections = 10;

@interface FRPageView ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>


@property(nonatomic, weak)FRPageViewFlowLayout *flowLayout;

@property (nonatomic, strong) UICollectionView *pageCollectionView;

@property (nonatomic, strong) NSTimer *timer;

//当前section
@property (nonatomic, assign) NSInteger dequeingSection;

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, assign) CGFloat lastContentOffsetX;

@end

@implementation FRPageView


- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    //注册cell
    [self.pageCollectionView registerClass:[cellClass class] forCellWithReuseIdentifier:identifier];
}

- (FRPageViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forRow:(NSInteger)row {
    FRPageViewCell *cell = [self.pageCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:row inSection:self.dequeingSection?self.dequeingSection:0]];
    return cell;
}

- (void)setContentOffset:(CGPoint)contentOffset {
    [self.pageCollectionView setContentOffset:contentOffset];
}

- (void)reloadData {
    
    if (self.pageCount) [self pageControl];
    [self.pageCollectionView reloadData];
    if (_timer == nil && _autoScroll) [self addTimer];
    [self scrollViewScrollToCenter];
}

- (void)scrollViewScrollToCenter {
    NSInteger row = self.pageControl.currentPage;
    if (!_pageCount) return;
    CGFloat flowLayout = [self.flowLayout cellWidth];
    CGFloat selfContentOffsetX = flowLayout * ((int)MaxSections / 2 * self.pageCount + row) - (self.bounds.size.width - flowLayout) * 0.5;
    if (self.pageViewScale == 1) {
        flowLayout += _itemSpacing;
        selfContentOffsetX = flowLayout * ((int)MaxSections / 2 * self.pageCount + row);
    }
    //隐式滚动，切换至中间section实现定时无限滚动效果
    [self.pageCollectionView setContentOffset:CGPointMake(selfContentOffsetX, 0) animated:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    if (bounds.size.width > 0) {
        self.pageCollectionView.frame = bounds;
        if (self.pageViewScale < 1) {
            CGFloat height = self.pageControl.controlSize.height;
            self.pageControl.frame = CGRectMake(0, bounds.size.height - height - 5, bounds.size.width, height);
        }else {
            self.pageControl.frame = CGRectMake(0, bounds.size.height - 15, bounds.size.width, 15);
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollViewScrollToCenter];
        });
    }
}

// 添加定时器
-(void) addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 删除定时器
-(void) removeTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)nextpage{
    
    if (!_pageCount) return;
    [self scrollViewScrollToCenter];
    CGFloat flowLayout = [self.flowLayout cellWidth];
    CGFloat selfContentOffsetX = self.pageCollectionView.contentOffset.x;
    //移动偏移量
    [self.pageCollectionView setContentOffset:CGPointMake(selfContentOffsetX + flowLayout, 0) animated:YES];
}

#pragma mark - collectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MaxSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger pageCount = [_dataSource FRPageView:self numberOfItemsInSection:section];
    self.pageCount = pageCount;
    return pageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.dequeingSection = indexPath.section;
    FRPageViewCell *cell = [_dataSource FRPageView:self cellForItemAtRow:indexPath.row];
    
    return cell;
}

#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (collectionView == _pageCollectionView) {
        if (_delegate && [_delegate respondsToSelector:@selector(FRPageView:didSelectItemAtRow:)]) {
            [_delegate FRPageView:self didSelectItemAtRow:indexPath.row];
        }
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.pageCollectionView) {//设置页码
        if (self.pageCount) {
            CGFloat scrollW = [self.flowLayout cellWidth];
            if (self.pageViewScale == 1) {
                scrollW += _itemSpacing;
            }
            int page = (int) (scrollView.contentOffset.x/scrollW+0.5)%self.pageCount;
            self.pageControl.currentPage = page;
            if (self.flowLayout && _delegate && [_delegate respondsToSelector:@selector(FRPageView:didScrollScale:)]) {
                
                [_delegate FRPageView:self didScrollScale:(scrollView.contentOffset.x + scrollView.contentInset.left)/[self.flowLayout cellWidth]];
            }
        }
        
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (_timer == nil) {
        [self scrollViewScrollToCenter];
        if(_autoScroll) [self addTimer];
    }
}


-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.pageCollectionView) {
        if(_autoScroll) [self removeTimer];
        self.lastContentOffsetX = scrollView.contentOffset.x;
    }
}

// 当用户停止的时候调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.pageCollectionView) {
        //手势没有惯性效果时执行
        if(!decelerate) [self pageScroll:scrollView haveDecelerating:NO];
    }
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.pageCollectionView){
        [self pageScroll:scrollView haveDecelerating:YES];
    }
}

/**
 实现scrollView滚动分页
 */
- (void)pageScroll:(UIScrollView *)scrollView haveDecelerating:(BOOL)haveDecelerating {
    if (self.pageViewScale == 1&&self.itemSpacing == 0) return;
    CGFloat moveW = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat width = [self.flowLayout cellWidth];
    CGFloat halfWidth = width * 0.5;
    if (self.pageViewScale == 1) {
        scrollViewW = scrollViewW + _itemSpacing;
        width += _itemSpacing;
    }
    CGFloat maxMoveW = scrollView.contentSize.width - scrollViewW;
    CGFloat halfMargin = (scrollViewW - width) * 0.5;
    
    CGFloat moveX = 0;
    
    if (haveDecelerating) {//有惯性的时候
        int selfCount = moveW/width;
        if (moveW > self.lastContentOffsetX) {//向右滑动跳转到下一view
            moveX = width * (selfCount + 1) - halfMargin;
        }else {//向左滑动跳转到上一view
            moveX = width * selfCount - halfMargin;
        }
    }else {
        int count = moveW/width;
        CGFloat remainderW = moveW - width * count;
        if (remainderW < halfWidth) {
            moveX = width * count - halfMargin;
        }else {
            moveX = width * (count + 1) - halfMargin;
        }
    }
    
    if (moveX > maxMoveW) {
        moveX = maxMoveW + halfMargin;
    }
    [scrollView setContentOffset:CGPointMake(moveX, 0) animated:YES];
}


#pragma mark - lazyLoad
- (UICollectionView *)pageCollectionView {
    if (!_pageCollectionView) {
        
        FRPageViewFlowLayout *layout = [[FRPageViewFlowLayout alloc] init];
        if(_pageViewScale) layout.itemScale = self.pageViewScale > 1?1:self.pageViewScale;
        if(_itemSpacing) layout.itemSpacing = self.itemSpacing < 0?0:self.itemSpacing;
        self.flowLayout = layout;
        
        _pageCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        if(self.pageViewScale == 1&&_itemSpacing == 0)_pageCollectionView.pagingEnabled = YES;
        _pageCollectionView.showsHorizontalScrollIndicator = NO;
        _pageCollectionView.bounces = NO;
        _pageCollectionView.backgroundColor = [UIColor clearColor];
        _pageCollectionView.dataSource = self;
        _pageCollectionView.delegate = self;
        
        
        CGFloat cellWidth = [layout cellWidth];
        CGFloat insetMargin = (self.bounds.size.width - cellWidth) * 0.5;
        [_pageCollectionView setContentInset:UIEdgeInsetsMake(0, insetMargin, 0, insetMargin)];
        [_pageCollectionView setContentOffset:CGPointMake(-insetMargin, 0)];
        
        //轮播广告
        [self addSubview:self.pageCollectionView];
        
    }
    return _pageCollectionView;
}


- (FRPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[FRPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.enabled = NO;
        _pageControl.controlSpacing = 8.0;
        _pageControl.controlSize = CGSizeMake(6, 6);
        [self insertSubview:_pageControl aboveSubview:self.pageCollectionView];
    }
    _pageControl.numberOfPages = self.pageCount;
    
    return _pageControl;
}

- (CGFloat)pageViewScale {
    if (!_pageViewScale) {
        _pageViewScale = 1.0;
    }
    return _pageViewScale;
}


@end
