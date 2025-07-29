//
//  DetailVC.m
//  Weather Forecast
//
//  Created by xiaoli pop on 2025/7/29.
//

#import "DetailVC.h"
#import "DataOfAddedCity.h"
@interface DetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray* forecastMutableArray;
@property (nonatomic, strong)UIImageView* backView;
@property (nonatomic, strong)UITableView* tableView;
@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.forecastMutableArray = [NSMutableArray array];
    [self getWeatherData];
    [self creatTableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell01"];
    [self.tableView reloadData];
}


- (void)pressDelete {
    DataOfAddedCity* singleton = [DataOfAddedCity sharedInstance];
    [singleton.mutableArray removeObjectAtIndex:self.pageIndex];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getWeatherData {
    NSArray* forecastArray = self.data[@"forecast"][@"forecastday"];
    for (NSDictionary* dayInfo in forecastArray) {
        NSString* date = dayInfo[@"date"];
        NSDictionary* day = dayInfo[@"day"];
       // NSArray* hourArray = dayInfo[@"hour"];
        NSString* maxTemp = [NSString stringWithFormat:@"%@", day[@"maxtemp_c"]];
        NSString* minTemp = [NSString stringWithFormat:@"%@", day[@"mintemp_c"]];
        NSString* condition = day[@"condition"][@"text"];
        
        NSDictionary* dict = @{
            @"date" : [date substringWithRange:NSMakeRange(5, 5)],
            @"weather" : [condition copy],
            @"temperature" : [NSString stringWithFormat:@"%@℃ - %@℃",minTemp, maxTemp]
        };
        [self.forecastMutableArray addObject:dict];
        NSDictionary* todayInfo = forecastArray[0];
        NSDictionary* today = todayInfo[@"day"];
        NSInteger code = [today[@"condition"][@"code"] integerValue];
        NSString* imageName;
        if (code == 1000) {
            imageName = @"p5.jpg";
        } else if (code == 1003 || code == 1006 || code == 1009) {
            imageName = @"p2.jpg";
        } else if ((code == 1063) || (code >= 1150 && code <= 1207) || (code >= 1240 && code <= 1246)) {
            imageName = @"p1.jpg";
        } else if ((code == 1066 || code == 1069 || code == 1072 || code == 1114 || code == 1117) || (code >= 1210 && code <= 1237) || (code >= 1255 && code <= 1264)) {
            imageName = @"p4.jpg";
        }
        else if (code == 1087 || (code >= 1273 && code <= 1282)) {
            imageName = @"p3.jpg";
        } else {
            imageName = @"p2.jpg";
        }
        UIImage* image = [UIImage imageNamed:imageName];
        self.backView = [[UIImageView alloc] initWithImage:image];
        self.backView.frame = self.view.frame;
        self.backView.clipsToBounds = YES;
        self.backView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view insertSubview:self.backView atIndex:0];
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell01" forIndexPath:indexPath];

    // 清除旧内容，防止复用时重复添加
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"删除" forState:UIControlStateNormal];
    button.frame = CGRectMake(345, 0, 50, 30);
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pressDelete) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];

    // 创建并添加 label 到 cell.contentView
    NSArray* forecastweather = self.data[@"forecast"][@"forecastday"];
    NSDictionary* dayInfo = forecastweather[0];
    NSDictionary* today = dayInfo[@"day"];

    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = [self.data[@"location"][@"name"] copy];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont fontWithName:@"Slideqiuhong-Regular" size:50];
    label1.center = CGPointMake(self.view.frame.size.width / 2, 60);
    [cell.contentView addSubview:label1];

    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(51, 100, 300, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%@",today[@"condition"][@"text"]];
    label.font = [UIFont systemFontOfSize:30 weight:UIFontWeightLight];
    [cell.contentView addSubview:label];

    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(51, 150, 300, 80)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    label2.text = [NSString stringWithFormat:@"%@℃",self.data[@"current"][@"temp_c"]];
    label2.font = [UIFont systemFontOfSize:70 weight:UIFontWeightLight];
    [cell.contentView addSubview:label2];

    UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(51, 230, 300, 50)];
    label3.backgroundColor = [UIColor clearColor];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor whiteColor];
    label3.text = [NSString stringWithFormat:@"体感温度:%@℃",self.data[@"current"][@"feelslike_c"]];
    label3.font = [UIFont systemFontOfSize:30 weight:UIFontWeightLight];
    [cell.contentView addSubview:label3];
    
    UILabel* container = [[UILabel alloc] initWithFrame:CGRectMake(10, 300,self.view.frame.size.width - 20 , 250)];
    container.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.26];
    container.layer.masksToBounds = YES;
    container.layer.cornerRadius = 20;
    
    UILabel* detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont systemFontOfSize:22];
    detailLabel.text = @"天气详情";
    detailLabel.textColor = [UIColor whiteColor];
    [container addSubview:detailLabel];
    
  
    UILabel* label4 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 160, 50)];
    label4.backgroundColor = [UIColor clearColor];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.textColor = [UIColor whiteColor];
    label4.text = [NSString stringWithFormat:@"最高温度:%@℃",today[@"maxtemp_c"]];
    label4.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    [container addSubview:label4];

    UILabel* label5 = [[UILabel alloc] initWithFrame:CGRectMake(container.frame.size.width - 170, 40, 160, 50)];
    label5.backgroundColor = [UIColor clearColor];
    label5.textAlignment = NSTextAlignmentCenter;
    label5.textColor = [UIColor whiteColor];
    label5.text = [NSString stringWithFormat:@"最低温度:%@℃",today[@"mintemp_c"]];
    label5.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    [container addSubview:label5];
    
    UILabel* label6 = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 160, 50)];
    label6.backgroundColor = [UIColor clearColor];
    label6.textAlignment = NSTextAlignmentLeft;
    label6.textColor = [UIColor whiteColor];
    label6.text = [NSString stringWithFormat:@"当前风速:%@km/h",self.data[@"current"][@"wind_kph"]];
    label6.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    [container addSubview:label6];

    UILabel* label7 = [[UILabel alloc] initWithFrame:CGRectMake(container.frame.size.width - 170, 90, 160, 50)];
    label7.backgroundColor = [UIColor clearColor];
    label7.textAlignment = NSTextAlignmentCenter;
    label7.textColor = [UIColor whiteColor];
    label7.text = [NSString stringWithFormat:@"当前湿度:%@%%",self.data[@"current"][@"humidity"]];
    label7.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    [container addSubview:label7];
    
    UILabel* label8 = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 160, 50)];
    label8.backgroundColor = [UIColor clearColor];
    label8.textAlignment = NSTextAlignmentLeft;
    label8.textColor = [UIColor whiteColor];
    label8.text = [NSString stringWithFormat:@"紫外线指数:%@ ",self.data[@"current"][@"uv"]];
    label8.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    [container addSubview:label8];

    UILabel* label9 = [[UILabel alloc] initWithFrame:CGRectMake(container.frame.size.width - 170, 140, 160, 50)];
    label9.backgroundColor = [UIColor clearColor];
    label9.textAlignment = NSTextAlignmentCenter;
    label9.textColor = [UIColor whiteColor];
    label9.text = [NSString stringWithFormat:@"能见度:%@公里",self.data[@"current"][@"vis_km"]];
    label9.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    [container addSubview:label9];
    
    UILabel* label10 = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, 160, 50)];
    label10.backgroundColor = [UIColor clearColor];
    label10.textAlignment = NSTextAlignmentLeft;
    label10.textColor = [UIColor whiteColor];
    label10.text = [NSString stringWithFormat:@"炎热指数:%@℃",self.data[@"current"][@"heatindex_c"]];
    label10.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    [container addSubview:label10];

    UILabel* label11 = [[UILabel alloc] initWithFrame:CGRectMake(container.frame.size.width - 170, 190, 160, 50)];
    label11.backgroundColor = [UIColor clearColor];
    label11.textAlignment = NSTextAlignmentCenter;
    label11.textColor = [UIColor whiteColor];
    label11.text = [NSString stringWithFormat:@"当前云量:%@%%",self.data[@"current"][@"cloud"]];
    label11.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    [container addSubview:label11];

    [cell.contentView addSubview:container];

    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 580, self.view.frame.size.width - 20, 100)];
    scrollView.layer.masksToBounds = YES;
    scrollView.layer.cornerRadius = 20;
    scrollView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.26];
    [cell.contentView addSubview:scrollView];
    
    NSString* localTime = self.data[@"location"][@"localtime"];
    NSLog(@"%@", localTime);
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-ddd HH:mm";
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    NSDate* nowDate = [formatter dateFromString:localTime];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSCalendarUnitHour) fromDate:nowDate];
    NSInteger currenrHour = components.hour;
    NSMutableArray* hourArray0 = [NSMutableArray array];
    for (NSInteger hour = currenrHour + 1; hour <= 23; hour++) {
        [hourArray0 addObject:@(hour)];
    }
   
    UIStackView* stackView = [[UIStackView alloc] init];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:stackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [stackView.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor constant:10],
        [stackView.topAnchor constraintEqualToAnchor:scrollView.topAnchor constant:10],
        [stackView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor constant:-10],
        [stackView.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor constant:-10],
        [stackView.heightAnchor constraintEqualToAnchor:scrollView.heightAnchor constant:-20]
    ]];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = 40;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentCenter;
   
//    NSArray* forecastweather = self.responseData[@"forecast"][@"forecastday"];
//    NSDictionary* dayInfo = forecastweather[0];
//    NSDictionary* today = dayInfo[@"day"];
//
    NSArray* hourArray = dayInfo[@"hour"];
    NSMutableArray* futureHours = [NSMutableArray array];
    for (NSDictionary* hourInfo in hourArray) {
        NSString* time = hourInfo[@"time"];
        NSString* hourStr = [time substringWithRange:NSMakeRange(11, 2)];
        NSInteger hourInt = [hourStr integerValue];
        if (hourInt > currenrHour && hourInt < 24) {
            [futureHours addObject:hourInfo];
        }
    }
    

    for (NSDictionary* hourInfo in futureHours) {
        NSString* iconUrl = hourInfo[@"condition"][@"icon"];
        if ([iconUrl hasPrefix:@"//"]) {
            iconUrl = [@"https:" stringByAppendingString:iconUrl];
        }
        NSString* time = hourInfo[@"time"];
        NSString* timeStr = [time substringWithRange:NSMakeRange(11, 2)];
        UIStackView* verticalStack = [[UIStackView alloc] init];
        verticalStack.axis = UILayoutConstraintAxisVertical;
        verticalStack.spacing = 4;
        verticalStack.alignment = UIStackViewAlignmentCenter;
        verticalStack.distribution = UIStackViewDistributionEqualSpacing;
        verticalStack.translatesAutoresizingMaskIntoConstraints = NO;
        [verticalStack.widthAnchor constraintEqualToConstant:60].active = YES;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%@时",timeStr];

        // 加载图片异步处理
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrl]];
            UIImage* image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(),^{
                imageView.image = image;
            });
        });
        [verticalStack addArrangedSubview:imageView];
        [verticalStack addArrangedSubview:label];

        [stackView addArrangedSubview:verticalStack];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel* container2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 700,self.view.frame.size.width - 20 , 300)];
    container2.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.26];
    container2.layer.masksToBounds = YES;
    container2.layer.cornerRadius = 20;
    
    for (int i = 0; i < 3; i++) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, i * 100, self.view.frame.size.width, 100)];
        view.backgroundColor = [UIColor clearColor];
        NSDictionary* dict = self.forecastMutableArray[i];
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 100)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.text = [dict[@"date"] copy];
        timeLabel.font = [UIFont systemFontOfSize:20];
        timeLabel.textColor = [UIColor whiteColor];
        
        UILabel* weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, 100)];
        weatherLabel.backgroundColor = [UIColor clearColor];
        weatherLabel.text = [dict[@"weather"] copy];
        weatherLabel.font = [UIFont systemFontOfSize:20];
        weatherLabel.textColor = [UIColor whiteColor];
        
        UILabel* tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 0, 170, 100)];
        tempLabel.backgroundColor = [UIColor clearColor];
        tempLabel.text = [dict[@"temperature"] copy];
        tempLabel.font = [UIFont systemFontOfSize:20];
        tempLabel.textColor = [UIColor whiteColor];
        [view addSubview:timeLabel];
        [view addSubview:weatherLabel];
        [view addSubview:tempLabel];
        
        [container2 addSubview:view];
    }
    
    
    [cell.contentView addSubview:container2];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height * 2;
}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
