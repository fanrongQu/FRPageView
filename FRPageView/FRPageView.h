//
//  FRPageView.h
//  FRPageView
//
//  Created by mac on 2017/7/25.
//  Copyright © 2017年 fanrongQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRPageViewCell.h"
#import "FRPageControl.h"

@class FRPageView;
@protocol FRPageViewDataSource <NSObject>

@required
/**
 数据源方法设置pageView页面数目

 @param pageView FRPageView对象
 @return pageView页面数目
 */
- (NSInteger)FRPageView:(FRPageView *)pageView numberOfItemsInSection:(NSInteger)section;

/**
 数据源方法设置对应view的数据

 @param pageView FRPageView对象
 @param row 对应view的序号
 @return FRPageViewCell对象
 */
- (FRPageViewCell *)FRPageView:(FRPageView *)pageView cellForItemAtRow:(NSInteger)row;

@end

@protocol FRPageViewDelegate <NSObject>

@optional
/**
 点击pageView的代理方法

 @param pageView FRPageView对象
 @param row 对应view的序号
 */
- (void)FRPageView:(FRPageView *)pageView didSelectItemAtRow:(NSInteger)row;

/**
 pageView当前滚动页面偏移比例（相对于pageView的宽度）

 @param pageView FRPageView对象
 @param scale 页面偏移比例
 */
- (void)FRPageView:(FRPageView *)pageView didScrollScale:(CGFloat)scale;

@end

@interface FRPageView : UIView

/**
 自动滚动
 */
@property (nonatomic, assign) BOOL autoScroll;
/**
 view缩放比例
 */
@property (nonatomic, assign) CGFloat pageViewScale;
/**
 view间距
 */
@property (nonatomic, assign) CGFloat itemSpacing;

@property (nonatomic, strong) FRPageControl *pageControl;

@property(nonatomic, weak)id<FRPageViewDataSource> dataSource;

@property(nonatomic, weak)id<FRPageViewDelegate> delegate;


- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

- (FRPageViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forRow:(NSInteger)row;

- (void)reloadData;

- (void)setContentOffset:(CGPoint)contentOffset;

@end
