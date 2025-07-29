//
//  DetailVC.h
//  Weather Forecast
//
//  Created by xiaoli pop on 2025/7/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailVC : UIViewController
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong)NSDictionary* data;
@end

NS_ASSUME_NONNULL_END
