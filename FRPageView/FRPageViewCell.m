//
//  FRPageViewCell.m
//  FRPageView
//
//  Created by mac on 2017/7/25.
//  Copyright © 2017年 fanrongQu. All rights reserved.
//

#import "FRPageViewCell.h"

@implementation FRPageViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_imageView) _imageView.frame = self.bounds;
    if (_titleLabel) {
        _bottomView.frame = CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30);
        _titleLabel.frame = CGRectMake(10, 0, self.bounds.size.width - 20, 30);
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView setImage:[UIImage imageNamed:@"1"]];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30)];
        _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self.contentView addSubview:_bottomView];
    }
    return _bottomView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 20, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        [self.bottomView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
