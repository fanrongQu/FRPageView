//
//  ViewController.m
//  FRPageView
//
//  Created by mac on 2017/8/2.
//  Copyright © 2017年 fanrongQu. All rights reserved.
//

#import "ViewController.h"
#import "FRPageView.h"

@interface ViewController ()<
FRPageViewDataSource,
FRPageViewDelegate>

@property (strong, nonatomic) NSArray<NSString *> *imageNames;
@property (strong, nonatomic) FRPageView *pageBgView;

@property (strong, nonatomic) FRPageView *pageView;

@property (strong, nonatomic) FRPageView *page2View;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageNames = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg"];
    [self.pageBgView reloadData];
    [self.pageView reloadData];
    [self.page2View reloadData];
}
#pragma mark - FRPageView dataSource
- (NSInteger)FRPageView:(FRPageView *)pageView numberOfItemsInSection:(NSInteger)section {
    return self.imageNames.count;
}

- (FRPageViewCell *)FRPageView:(FRPageView *)pageView cellForItemAtRow:(NSInteger)row {
    FRPageViewCell *cell;
    if ([pageView isEqual:self.pageView]) {
        cell = [pageView dequeueReusableCellWithReuseIdentifier:@"FRPageViewCell" forRow:row];
        [cell.imageView setImage:[UIImage imageNamed:self.imageNames[row]]];
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        cell.imageView.clipsToBounds = YES;
        [cell.imageView.layer setCornerRadius:5.0];
        [cell.imageView.layer setMasksToBounds:YES];
    }else if([pageView isEqual:self.pageBgView]){
        
        cell = [pageView dequeueReusableCellWithReuseIdentifier:@"FRpageBgViewCell" forRow:row];
        [cell.imageView setImage:[UIImage imageNamed:self.imageNames[row]]];
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        cell.imageView.clipsToBounds = YES;
    }else if([pageView isEqual:self.page2View]){
        
        cell = [pageView dequeueReusableCellWithReuseIdentifier:@"FRpage2ViewCell" forRow:row];
        [cell.imageView setImage:[UIImage imageNamed:self.imageNames[row]]];
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        cell.imageView.clipsToBounds = YES;
    }
    return cell;
}


#pragma mark - FRPageView delegate
- (void)FRPageView:(FRPageView *)pageView didSelectItemAtRow:(NSInteger)row {
    if ([pageView isEqual:self.pageView]) {
        NSLog(@"FRPageViewDidSelectItemAtRow: %ld",(long)row);
    }
}

- (void)FRPageView:(FRPageView *)pageView didScrollScale:(CGFloat)scale {
    if ([pageView isEqual:self.pageView]) {
        [self.pageBgView setContentOffset:CGPointMake(self.pageBgView.bounds.size.width * scale, 0)];
    }
}


- (FRPageView *)pageBgView {
    if (!_pageBgView) {
        _pageBgView = [[FRPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 244)];
        _pageBgView.dataSource = self;
        _pageBgView.delegate = self;
        _pageBgView.pageControl.hidden = YES;
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = _pageBgView.bounds;
        [_pageBgView addSubview:effectView];
        
        [_pageBgView registerClass:[FRPageViewCell class] forCellWithReuseIdentifier:@"FRpageBgViewCell"];
        [self.view addSubview:_pageBgView];
    }
    return _pageBgView;
}

- (FRPageView *)pageView {
    if (!_pageView) {
        _pageView = [[FRPageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 180)];
        _pageView.dataSource = self;
        _pageView.delegate = self;
        _pageView.backgroundColor = [UIColor clearColor];
        _pageView.pageViewScale = 0.80;
        _pageView.itemSpacing = 100;
        _pageView.autoScroll = YES;
        _pageView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        _pageView.pageControl.controlSpacing = 3.0;
        _pageView.pageControl.controlSize = CGSizeMake(15, 2);
        
        [_pageView registerClass:[FRPageViewCell class] forCellWithReuseIdentifier:@"FRPageViewCell"];
        [self.view addSubview:_pageView];
    }
    return _pageView;
}


- (FRPageView *)page2View {
    if (!_page2View) {
        _page2View = [[FRPageView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 180)];
        _page2View.dataSource = self;
        _page2View.delegate = self;
        [_page2View registerClass:[FRPageViewCell class] forCellWithReuseIdentifier:@"FRpage2ViewCell"];
        [self.view addSubview:_page2View];
    }
    return _page2View;
}



@end
