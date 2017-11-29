//
//  FRPageControl.h
//  FRPageView
//
//  Created by mac on 2017/8/1.
//  Copyright © 2017年 fanrongQu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRPageControl : UIControl

@property(nonatomic) NSInteger numberOfPages;          // default is 0
@property(nonatomic) NSInteger currentPage;            // default is 0. value pinned to 0..numberOfPages-1
@property (nonatomic) CGFloat controlSpacing;          // The spacing to use between page indicators in the page control.

@property (nonatomic) CGSize controlSize;

@property(nonatomic) BOOL hidesForSinglePage;          // hide the the indicator if there is only one page. default is NO

@property(nonatomic) BOOL defersCurrentPageDisplay;    // if set, clicking to a new page won't update the currently displayed page until -updateCurrentPageDisplay is called. default is NO
//- (void)updateCurrentPageDisplay;                      // update page display to match the currentPage. ignored if defersCurrentPageDisplay is NO. setting the page value directly will update immediately
//
//- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;   // returns minimum size required to display dots for given page count. can be used to size control if page count could change

@property(nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;
@property(nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;

@end
