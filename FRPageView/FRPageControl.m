//
//  FRPageControl.m
//  FRPageView
//
//  Created by mac on 2017/8/1.
//  Copyright © 2017年 fanrongQu. All rights reserved.
//

#import "FRPageControl.h"

@interface FRPageControl ()

@property(nonatomic,strong) UIImage *currentBkImg;     //  当前点背景颜色

@end

@implementation FRPageControl



-(instancetype)init{
    if(self=[super init]) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self initialize];
        
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self createPointView];
}

-(void)initialize{
    self.backgroundColor=[UIColor clearColor];
    _numberOfPages=0;
    _currentPage=0;
    _controlSize = CGSizeMake(5, 5);
    _controlSpacing = 8;
    _pageIndicatorTintColor=[UIColor redColor];
    _currentPageIndicatorTintColor=[UIColor blueColor];
    
    // [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    //    [self addGestureRecognizer:tapGesture];
}

-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    
    if(![self isTheSameColor:pageIndicatorTintColor anpageIndicatorTintColor:_pageIndicatorTintColor]){
        
        _pageIndicatorTintColor=pageIndicatorTintColor;
        [self createPointView];
    }
}

-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    if(![self isTheSameColor:currentPageIndicatorTintColor anpageIndicatorTintColor:_currentPageIndicatorTintColor]){
        _currentPageIndicatorTintColor=currentPageIndicatorTintColor;
        [self createPointView];
    }
}

-(void)setControlSize:(CGSize)controlSize{
    if(controlSize.width!=_controlSize.width || controlSize.height!=_controlSize.height){
        _controlSize=controlSize;
        [self createPointView];
        
    }
}

-(void)setControlSpacing:(CGFloat)controlSpacing{
    if(_controlSpacing!=controlSpacing){
        
        _controlSpacing=controlSpacing;
        [self createPointView];
        
    }
}

-(void)setCurrentBkImg:(UIImage *)currentBkImg{
    if(_currentBkImg!=currentBkImg){
        _currentBkImg=currentBkImg;
        [self createPointView];
    }
}

-(void)setNumberOfPages:(NSInteger)page{
    if(_numberOfPages==page)
        return;
    _numberOfPages=page;
    [self createPointView];
}

-(void)setCurrentPage:(NSInteger)currentPage{
    
    
//    if([self.delegate respondsToSelector:@selector(ellipsePageControlClick:index:)])
//    {
//        [self.delegate ellipsePageControlClick:self index:currentPage];
//    }
    
    if(_currentPage==currentPage)
        return;
    _currentPage=currentPage;
    [self createPointView];
    
}

-(void)clearView{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}



-(void)createPointView{
    [self clearView];
    if(_numberOfPages<=0)
        return;
    
    //居中控件
    CGFloat startX=0;
    CGFloat startY=0;
    CGFloat controlSizeW = _controlSize.width;
    CGFloat controlSizeH = _controlSize.height;
    CGFloat mainWidth=_numberOfPages*(controlSizeW +_controlSpacing);
    if(self.frame.size.width<mainWidth){
        startX=0;
    }else{
        startX=(self.frame.size.width-mainWidth)/2;
    }
    if(self.frame.size.height<controlSizeH){
        startY=0;
    }else{
        startY=(self.frame.size.height-controlSizeH)/2;
    }
    //动态创建点
    for (int page=0; page<_numberOfPages; page++) {
        if(page==_currentPage){
            UIView *currPointView=[[UIView alloc]initWithFrame:CGRectMake(startX, startY, controlSizeW, controlSizeH)];
            currPointView.layer.cornerRadius=controlSizeH/2;
            currPointView.tag=page+1000;
            currPointView.backgroundColor=_currentPageIndicatorTintColor;
            currPointView.userInteractionEnabled=YES;
            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
            [currPointView addGestureRecognizer:tapGesture];
            [self addSubview:currPointView];
            startX=CGRectGetMaxX(currPointView.frame)+_controlSpacing;
            
            
            if(_currentBkImg){
                currPointView.backgroundColor=[UIColor clearColor];
                UIImageView *currBkImg=[UIImageView new];
                currBkImg.tag=1234;
                currBkImg.frame=CGRectMake(0, 0, currPointView.frame.size.width, currPointView.frame.size.height);
                currBkImg.image=_currentBkImg;
                [currPointView addSubview:currBkImg];
            }
            
        }else{
            UIView *otherPointView=[[UIView alloc]initWithFrame:CGRectMake(startX, startY, controlSizeW, controlSizeH)];
            otherPointView.backgroundColor=_pageIndicatorTintColor;
            otherPointView.tag=page+1000;
            otherPointView.layer.cornerRadius=controlSizeH/2;
            otherPointView.userInteractionEnabled=YES;
            
            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
            [otherPointView addGestureRecognizer:tapGesture];
            [self addSubview:otherPointView];
            startX=CGRectGetMaxX(otherPointView.frame)+_controlSpacing;
        }
    }
    
}


-(void)clickAction:(UITapGestureRecognizer*)recognizer{
    
    NSInteger index=recognizer.view.tag-1000;
    [self setCurrentPage:index];
}


-(BOOL)isTheSameColor:(UIColor*)color1 anpageIndicatorTintColor:(UIColor*)color2{
    return  CGColorEqualToColor(color1.CGColor, color2.CGColor);
}



@end
