//
//  DataOfAddedCity.h
//  Weather Forecast
//
//  Created by xiaoli pop on 2025/7/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataOfAddedCity : NSObject
@property (nonatomic, strong)NSMutableArray* mutableArray;
+ (id)sharedInstance;
@end

NS_ASSUME_NONNULL_END
