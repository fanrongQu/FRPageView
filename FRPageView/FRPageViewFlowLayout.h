//
//  FRPageViewFlowLayout.h
//  FRPageView
//
//  Created by mac on 2017/7/28.
//  Copyright © 2017年 fanrongQu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRPageViewFlowLayout : UICollectionViewFlowLayout

- (CGFloat)cellWidth;

@property (nonatomic, assign) CGFloat itemScale;

@property (nonatomic, assign) CGFloat itemSpacing;

@end
