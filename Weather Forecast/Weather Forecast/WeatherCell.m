//
//  WeatherCell.m
//  Weather Forecast
//
//  Created by xiaoli pop on 2025/7/17.
//

#import "WeatherCell.h"

@implementation WeatherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.width - 20, 130)];
        self.iView.clipsToBounds = YES;
        self.iView.layer.masksToBounds = YES;
        self.iView.layer.cornerRadius = 10;
        [self.contentView addSubview:self.iView];
        self.CityName = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 50)];
        self.CityName.backgroundColor = [UIColor clearColor];
        self.CityName.textColor = [UIColor whiteColor];
        self.CityName.font = [UIFont systemFontOfSize:30];
        [self.iView addSubview:self.CityName];
        
        self.temperature = [[UILabel alloc] initWithFrame:CGRectMake(22, 70, 200, 30)];
        self.temperature.backgroundColor = [UIColor clearColor];
        self.temperature.textColor = [UIColor whiteColor];
        self.temperature.font = [UIFont systemFontOfSize:27];
        [self.iView addSubview:self.temperature];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
