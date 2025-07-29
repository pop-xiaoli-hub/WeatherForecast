//
//  ShowViewController.m
//  Weather Forecast
//
//  Created by xiaoli pop on 2025/7/26.
//

#import "ShowViewController.h"
#import "DataOfAddedCity.h"
@interface ShowViewController ()<NSURLSessionDelegate, NSURLSessionDataDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSArray* backViewArray;
@property (nonatomic, strong)NSNumber* code;
@property (nonatomic, strong)NSDictionary* responseData;
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)UIImageView* backView;
@property (nonatomic, strong)NSMutableArray* forecastMutableArray;
@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.forecastMutableArray = [NSMutableArray array];
    self.backViewArray = @[@"p1.jpg", @"p2.jpg", @"p3.jpg", @"p4.jpg", @"p5.jpg"];
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    NSLog(@"%@", self.CityName);
    [self creatUrl];
}

- (void)creatAddButton {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"添加" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 50, 30);
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pressAdd) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* left = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = left;
}


- (void)pressAdd {
    NSDictionary* userInfo = [self.responseData mutableCopy];
    DataOfAddedCity* singleton = [DataOfAddedCity sharedInstance];
    for (NSDictionary* dict in singleton.mutableArray) {
        if ([userInfo[@"location"][@"name"] isEqualToString:dict[@"location"][@"name"]]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"不可重复添加" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notice" object:nil userInfo:userInfo];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell01" forIndexPath:indexPath];

    // 清除旧内容，防止复用时重复添加
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }

    // 创建并添加 label 到 cell.contentView
    NSArray* forecastweather = self.responseData[@"forecast"][@"forecastday"];
    NSDictionary* dayInfo = forecastweather[0];
    NSDictionary* today = dayInfo[@"day"];

    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = [self.CityName copy];
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
    label2.text = [NSString stringWithFormat:@"%@℃",self.responseData[@"current"][@"temp_c"]];
    label2.font = [UIFont systemFontOfSize:70 weight:UIFontWeightLight];
    [cell.contentView addSubview:label2];

    UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(51, 230, 300, 50)];
    label3.backgroundColor = [UIColor clearColor];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor whiteColor];
    label3.text = [NSString stringWithFormat:@"体感温度:%@℃",self.responseData[@"current"][@"feelslike_c"]];
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
    label6.text = [NSString stringWithFormat:@"当前风速:%@km/h",self.responseData[@"current"][@"wind_kph"]];
    label6.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    [container addSubview:label6];

    UILabel* label7 = [[UILabel alloc] initWithFrame:CGRectMake(container.frame.size.width - 170, 90, 160, 50)];
    label7.backgroundColor = [UIColor clearColor];
    label7.textAlignment = NSTextAlignmentCenter;
    label7.textColor = [UIColor whiteColor];
    label7.text = [NSString stringWithFormat:@"当前湿度:%@%%",self.responseData[@"current"][@"humidity"]];
    label7.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    [container addSubview:label7];
    
    UILabel* label8 = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 160, 50)];
    label8.backgroundColor = [UIColor clearColor];
    label8.textAlignment = NSTextAlignmentLeft;
    label8.textColor = [UIColor whiteColor];
    label8.text = [NSString stringWithFormat:@"紫外线指数:%@ ",self.responseData[@"current"][@"uv"]];
    label8.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    [container addSubview:label8];

    UILabel* label9 = [[UILabel alloc] initWithFrame:CGRectMake(container.frame.size.width - 170, 140, 160, 50)];
    label9.backgroundColor = [UIColor clearColor];
    label9.textAlignment = NSTextAlignmentCenter;
    label9.textColor = [UIColor whiteColor];
    label9.text = [NSString stringWithFormat:@"能见度:%@公里",self.responseData[@"current"][@"vis_km"]];
    label9.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    [container addSubview:label9];
    
    UILabel* label10 = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, 160, 50)];
    label10.backgroundColor = [UIColor clearColor];
    label10.textAlignment = NSTextAlignmentLeft;
    label10.textColor = [UIColor whiteColor];
    label10.text = [NSString stringWithFormat:@"炎热指数:%@℃",self.responseData[@"current"][@"heatindex_c"]];
    label10.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    [container addSubview:label10];

    UILabel* label11 = [[UILabel alloc] initWithFrame:CGRectMake(container.frame.size.width - 170, 190, 160, 50)];
    label11.backgroundColor = [UIColor clearColor];
    label11.textAlignment = NSTextAlignmentCenter;
    label11.textColor = [UIColor whiteColor];
    label11.text = [NSString stringWithFormat:@"当前云量:%@%%",self.responseData[@"current"][@"cloud"]];
    label11.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    [container addSubview:label11];

    [cell.contentView addSubview:container];

    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 580, self.view.frame.size.width - 20, 100)];
    scrollView.layer.masksToBounds = YES;
    scrollView.layer.cornerRadius = 20;
    scrollView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.26];
    [cell.contentView addSubview:scrollView];
    
    NSString* localTime = self.responseData[@"location"][@"localtime"];
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
    
//    for (NSDictionary* hourInfo in futureHours) {
//        NSString* iconUrl = hourInfo[@"condition"][@"icon"];
//        if ([iconUrl hasPrefix:@"//"]) {
//            iconUrl = [@"https:" stringByAppendingString:iconUrl];
//        }
//        NSString* time = hourInfo[@"time"];
//        NSString* timeStr = [time substringWithRange:NSMakeRange(11, 2)];
//        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
//        imageView.clipsToBounds = YES;
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        UILabel* label = [[UILabel alloc] init];
//        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
//            NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrl]];
//            UIImage* image = [UIImage imageWithData:imageData];
//            dispatch_async(dispatch_get_main_queue(),^{
//                imageView.image = image;
//                label.text = [timeStr copy];
//            });
//        });
//        [stackView addArrangedSubview:label];
//        [stackView addArrangedSubview:imageView];
//    }

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

- (void)creatUrl {
    NSString* urlString = [NSString stringWithFormat:@"https://api.weatherapi.com/v1/forecast.json?key=8f123b0cdc654b149aa92217252607&q=%@&days=3&lang=zh",self.CityName];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask* dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
}


/*
 服务器接收信息回调，这里的data是一个数据缓冲区，用来拼接数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"didReceiveResponse");
    if (self.data == nil) {
        self.data = [[NSMutableData alloc] init];
    } else {
        self.data.length = 0;
    }
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData");
    [self.data appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"didCompleteWithError");
    if (error == nil) {
        NSString* jsonString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        NSLog(@"原始字符串：%@", jsonString);
        NSError* parseError = nil;
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&parseError];
        self.responseData = responseDict;
        if (parseError) {
            return;
        }
        NSArray* forecastArray = responseDict[@"forecast"][@"forecastday"];
        for (NSDictionary* dayInfo in forecastArray) {
            NSString* date = dayInfo[@"date"];
            NSDictionary* day = dayInfo[@"day"];
            
            NSArray* hourArray = dayInfo[@"hour"];
            
            for (NSDictionary *hourInfo in hourArray) {
                   NSString *time = hourInfo[@"time"]; // 格式：2025-07-28 15:00
                   NSString *condition = hourInfo[@"condition"][@"text"];
                   NSString *iconUrl = hourInfo[@"condition"][@"icon"];
                   NSNumber *temp = hourInfo[@"temp_c"];
                   NSLog(@"%@ %@ 时：%@，%.1f℃，图标：%@", date, [time substringFromIndex:11], condition, temp.floatValue, iconUrl);
               }
            
            
            NSString* maxTemp = [NSString stringWithFormat:@"%@", day[@"maxtemp_c"]];
            NSString* minTemp = [NSString stringWithFormat:@"%@", day[@"mintemp_c"]];
            NSString* condition = day[@"condition"][@"text"];
            
            NSDictionary* dict = @{
                @"date" : [date substringWithRange:NSMakeRange(5, 5)],
                @"weather" : [condition copy],
                @"temperature" : [NSString stringWithFormat:@"%@℃ - %@℃",minTemp, maxTemp]
            };
            [self.forecastMutableArray addObject:dict];
            NSLog(@"日期：%@，天气：%@，最高温：%@℃，最低温：%@℃", date, condition, maxTemp, minTemp);
        }
        NSDictionary* todayInfo = forecastArray[0];  // 只取第一个元素
        NSDictionary* today = todayInfo[@"day"];
        self.code = today[@"condition"][@"code"];
        NSLog(@"%@", self.code);
        /*
         获取了一个全局并发队列（后台线程池），将要执行任务的优先级设为默认，将该任务放入这个队列中异步执行，避免阻塞主线程
         */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSInteger code = [self.code integerValue];
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
            dispatch_async(dispatch_get_main_queue(),^{
                self.backView = [[UIImageView alloc] initWithImage:image];
                self.backView.frame = self.view.frame;
                self.backView.clipsToBounds = YES;
                self.backView.contentMode = UIViewContentModeScaleAspectFill;
                [self.view insertSubview:self.backView atIndex:0];
                [self creatTableView];
                [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell01"];
                [self.tableView reloadData];
                [self creatAddButton];
            });
        });
    } else {
        NSLog(@"错误请求：%@", error.localizedDescription);
    }
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
