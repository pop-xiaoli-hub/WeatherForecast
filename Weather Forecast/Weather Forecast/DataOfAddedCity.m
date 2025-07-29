//
//  DataOfAddedCity.m
//  Weather Forecast
//
//  Created by xiaoli pop on 2025/7/28.
//

#import "DataOfAddedCity.h"
static DataOfAddedCity* instance = NULL;
@implementation DataOfAddedCity
+(id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!self.mutableArray) {
            self.mutableArray = [NSMutableArray array];
        }
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}


@end
