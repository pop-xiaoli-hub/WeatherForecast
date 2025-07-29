//
//  WeatherCell.h
//  Weather Forecast
//
//  Created by xiaoli pop on 2025/7/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherCell : UITableViewCell
@property (nonatomic, strong)UIImageView* iView;
@property (nonatomic, strong)UILabel* CityName;
@property (nonatomic, strong)UILabel* temperature;
@end

NS_ASSUME_NONNULL_END
