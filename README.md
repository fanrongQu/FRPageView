# FRPageView
自定义的轮播展示图效果，仿一号店首页轮播效果。并自定义pageControl

![](https://github.com/fanrongQu/FRPageView/blob/master/FRPageView.gif)

<p>再来个项目实际效果展示，下面就这挡着了奥🙆‍♂️🙆‍♂️🙆‍♂️</p>

![](https://github.com/fanrongQu/FRPageView/blob/master/FRPageView1.gif) 
<p>觉得不错请star🌟🌟🌟</p>

# 集成cocoaPods
```Objective-C
pod 'FRPageView'
```
# 使用方法
##### 头文件引入#import "FRPageView.h"

##### 创建FRPageView对象（可以通过frame和约束设置宽高），并在设置FRPageView对象的数据源方法（dataSource）和代理方法（delegate）类似于tableView
##### 注册FRPageViewCell
```Objective-C
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
```

##### 实现数据源及代理方法
```Objective-C
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
```
##### 其他属性
是否自动滚动
```Objective-C
@property (nonatomic, assign) BOOL autoScroll;
```
页面缩放比例
```Objective-C
@property (nonatomic, assign) CGFloat pageViewScale;
```
pageControl 可以通过pageControl设置一些对应的属性
```Objective-C
@property (nonatomic, strong) FRPageControl *pageControl;
```
