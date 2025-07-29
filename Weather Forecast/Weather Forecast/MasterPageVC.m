//
//  MasterPageVC.m
//  Weather Forecast
//
//  Created by xiaoli pop on 2025/7/29.
//

#import "MasterPageVC.h"
#import "DetailVC.h"
@interface MasterPageVC ()<UIPageViewControllerDataSource>

@end

@implementation MasterPageVC

- (instancetype)initWithData:(NSArray<NSDictionary*> *)data initialIndex:(NSInteger)index {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                     navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@10}];
    if (self) {
        self.dataArray = data;
        self.dataSource = self;
        DetailVC* initial = [self viewControllerAtIndex:index];
        [self setViewControllers:@[initial] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    return self;
}



- (DetailVC *)viewControllerAtIndex:(NSUInteger)idx {
    if (idx >= self.dataArray.count) return nil;
    DetailVC* vc = [[DetailVC alloc] init];
    vc.pageIndex = idx;
    vc.data = self.dataArray[idx];
    return vc;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)vc {
    NSInteger i = ((DetailVC*)vc).pageIndex;
    return i>0 ? [self viewControllerAtIndex:i-1] : nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)vc {
    NSInteger i = ((DetailVC*)vc).pageIndex;
    return i+1 < self.dataArray.count ? [self viewControllerAtIndex:i+1] : nil;
}

/*
 UIPageViewController的这两个协议方法可以在翻页的时候计算新的index
 */
@end
