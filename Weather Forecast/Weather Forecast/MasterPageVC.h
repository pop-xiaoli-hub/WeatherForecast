//
//  MasterPageVC.h
//  Weather Forecast
//
//  Created by xiaoli pop on 2025/7/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MasterPageVC : UIPageViewController
@property (nonatomic, strong)NSArray<NSDictionary* >* dataArray;
- (instancetype)initWithData:(NSArray<NSDictionary*> *)data initialIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
