//
//  ShowViewController.h
//  Weather Forecast
//
//  Created by xiaoli pop on 2025/7/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowViewController : UIViewController
@property (nonatomic, copy)NSString* CityName;
@property (nonatomic, strong)NSMutableData* data;
@end

NS_ASSUME_NONNULL_END
