//
//  OtherVC.m
//  Weather Forecast
//
//  Created by xiaoli pop on 2025/7/17.
//

#import "OtherVC.h"
#import "ShowViewController.h"
@interface OtherVC () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSArray* resultArray;
@property (nonatomic, strong)UISearchBar* searchBar;

@end

@implementation OtherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultArray = [NSArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSearchBar];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmisalKeyBoard)];
    tap.numberOfTapsRequired = 1;
    tap.cancelsTouchesInView = NO;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    [self createTableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell01"];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//}
//
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.resultArray = @[];
        [self.tableView reloadData];
        return;
    }
    [self searchCityWithName:searchText];
}

- (void)searchCityWithName:(NSString* )name {
    NSString *apiKey = @"467f2bf6c4234a32921e0f39da4d6b5c";
    NSString *encodedCityName = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSString *urlString = [NSString stringWithFormat:@"https://geoapi.qweather.com/v2/city/lookup?location=%@&key=%@", encodedCityName, apiKey];
    NSString *urlString = [NSString stringWithFormat:@"https://geoapi.qweather.com/v2/city/lookup?location=%@&key=%@", encodedCityName, apiKey];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    /*
     发起异步网络请求
     */
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error：%@", error.localizedDescription);
        } else {
            NSString *responseData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response：%@", responseData);
            
            NSError *jsonError = nil;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (!jsonError) {
                NSArray *locationArray = jsonObject[@"location"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableDictionary *uniqueCities = [NSMutableDictionary dictionary];
                    for (NSDictionary *city in locationArray) {
                        if ([city[@"type"] isEqualToString:@"city"]) {
                            // 拼接唯一key
                            NSString *key = [NSString stringWithFormat:@"%@-%@", city[@"adm1"], city[@"adm2"]];
                            if (!uniqueCities[key]) {
                                uniqueCities[key] = city;
                            }
                        }
                    }
                    self.resultArray = [uniqueCities allValues];
                    self.tableView.hidden = (locationArray.count == 0);
                    [self.tableView reloadData];
                });

                NSLog(@"搜索到的城市数组: %@", locationArray);
                // 在这里更新UI，展示城市搜索结果
            } else {
                NSLog(@"JSON解析失败：%@", jsonError.localizedDescription);
            }
        }
    }];
    
    [dataTask resume];
}







- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowViewController* vc = [[ShowViewController alloc] init];
    NSDictionary* dict = self.resultArray[indexPath.row];
    vc.CityName = [dict[@"adm2"] copy];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell01" forIndexPath:indexPath];
    NSDictionary* dict = self.resultArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",dict[@"adm1"], dict[@"adm2"]];
        return cell;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)dissmisalKeyBoard {
    [self.view endEditing:YES];
}

- (void)createSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.showsSearchResultsButton = YES;
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入城市名称";
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.searchBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.searchBar.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - 40, 50);
    self.searchBar.center = CGPointMake(self.view.center.x, 125);
    UITextField* search = self.searchBar.searchTextField;
    if (search) {
        search.frame = CGRectMake(0, 0, self.searchBar.frame.size.width, self.searchBar.frame.size.height);
        search.backgroundColor = [UIColor systemGray6Color];
        search.layer.cornerRadius = 10;
        search.clipsToBounds = YES;
        UIView* paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
        search.leftView = paddingView;
        search.leftViewMode = UITextFieldViewModeAlways;
    }
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 155, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 155);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
