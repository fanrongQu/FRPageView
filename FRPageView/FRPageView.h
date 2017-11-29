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
- (NSInteger)FRPageView:(FRPageView *)pageView numberOfItemsInSection:(NSInteger)section;

- (FRPageViewCell *)FRPageView:(FRPageView *)pageView cellForItemAtRow:(NSInteger)row;

@end

@protocol FRPageViewDelegate <NSObject>

@optional
- (void)FRPageView:(FRPageView *)pageView didSelectItemAtRow:(NSInteger)row;

- (void)FRPageView:(FRPageView *)pageView didScrollScale:(CGFloat)scale;

@end

@interface FRPageView : UIView

@property (nonatomic, assign) BOOL autoScroll;

@property (nonatomic, assign) CGFloat pageViewScale;

@property (nonatomic, strong) FRPageControl *pageControl;

@property(nonatomic, weak)id<FRPageViewDataSource> dataSource;

@property(nonatomic, weak)id<FRPageViewDelegate> delegate;


- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

- (FRPageViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forRow:(NSInteger)row;

- (void)reloadData;

- (void)setContentOffset:(CGPoint)contentOffset;

@end
